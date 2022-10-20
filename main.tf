provider "aws" {
  region = "us-east-1"
}

# DATA BLOCKS
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}
data "http" "my_home_ip" {
  url = "http://ipv4.icanhazip.com"
}
data "template_file" "userdata" {
  # template = file("./scripts/cloud-init.yml")
  template = file("./scripts/userdata.sh")
  vars = {
    vpc_id = module.infra.vpc_id
  }
}

locals {
  environment = "Prod"
  owner       = "Avenga"
  terraform   = "True"
}
locals {
  server_tags = {
    Environment = local.environment
    Owner       = local.owner
    Terraform   = local.terraform
  }
}
# MODULES BLOCKS
module "infra" {
  source      = "./modules/infra/"
  az          = "us-east-1a"
  subnet_cidr = "10.0.0.0/24"
  vpc_cidr    = "10.0.0.0/16"
}
# SERVER BLOCKS
resource "aws_instance" "avenga-server" {
  count                  = var.server_count
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.avenga-server-sg.id]
  subnet_id              = module.infra.subnet_id
  secondary_private_ips  = var.sec_ips
  key_name               = aws_key_pair.my-server.key_name
  tags                   = local.server_tags
  # user_data              = data.template_file.userdata.rendered
  # provisioner "local-exec" {
  #   command = "echo \"My IP address is ${self.private_ip}\" >> private_ips.txt"
  # }
  # provisioner "local-exec" {
  #   when       = destroy
  #   command    = "echo \"It was destroyed\" >> private_ips.txt"
  #   on_failure = continue
  # }
  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   host        = self.public_ip
  #   private_key = file("my-server")
  # }
  # provisioner "file" {
  #   source      = "scripts/script.sh"
  #   destination = "/tmp/script.sh"
  # }
  # provisioner "remote-exec" {
  #   inline = [
  #     "echo \"Initiate remote-exec. First command\" >> /tmp/re.txt",
  #     "echo \"Initiate remote-exec. Second command\" >> /tmp/re.txt",
  #     "chmod +x /tmp/script.sh",
  #     "/tmp/script.sh >> /tmp/re.txt"
  #   ]
  # }
}

resource "aws_security_group" "avenga-server-sg" {
  name        = "server access"
  description = "Allow server acces with SSH and HTTP"
  vpc_id      = module.infra.vpc_id
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_home_ip.response_body)}/32"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
resource "aws_key_pair" "my-server" {
  key_name   = "my-server"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCQKincHkfb0NXzznadiU3wlBjbaT1KxcvH5zIBsWxkeLTJT6UNFqSMulkpxrLVswHc/W4er6aOA7IqF592oW9zejQVjMP7kfqumbkYls2GP56jJF72mSf3UOvYxK9u798muH1Inx6diPRqqjGybZTvPAQXfK139G4YUj1MnKa5HcGnHY6cUfL5qW2/be1c0epNb2l8UiKLp9gLNNFd50EG0TQ4DgoVontDjisaAmqAwmhGKOnpUsEssFxK/LLzIBVTw0jmJaXDB/1CiR1ZpquSdgoi5kcmw3HFpNEG1N1Z/KC1oMphyzUvvGpM5Tp+TqWYCiFVKAwLUmYwRhFmG8gRA4//fsSqNLsS3ANqPHpmesP7i7zcBgW6/B0Yx89AFM/FNeNVJQ+VlYjpnq7Dsh12bNSKMNqWl942Lb6mHqUn01oNkL00O5jPzYbt373G2SS9zX9NT3tv+KYZ4fDS1NXUq/gNdIE0hMls9WpAs6l9DBFqy1VEz/kimrMrv74MtVk= avenga@avenga"
}

#WAF BLOCKS
# resource "aws_wafv2_ip_set" "firewall" {
#   for_each           = var.whitelisted_ips
#   name               = each.value["name"]
#   description        = each.value["description"]
#   scope              = "REGIONAL"
#   ip_address_version = "IPV4"
#   addresses          = each.value["addresses"]
#   tags = {
#     Priority  = each.value["priority"]
#     terraform = "true"
#   }
# }
# resource "aws_wafv2_rule_group" "firewall_rules" {
#   name     = "my-firewall-rules"
#   scope    = "REGIONAL"
#   capacity = 30
#   dynamic "rule" {
#     for_each = aws_wafv2_ip_set.firewall
#     content {
#       name     = rule.value["name"]
#       priority = aws_wafv2_ip_set.firewall[rule.key].tags.Priority
#       action {
#         allow {}
#       }
#       statement {
#         ip_set_reference_statement {
#           arn = aws_wafv2_ip_set.firewall[rule.key].arn
#         }
#       }
#       visibility_config {
#         cloudwatch_metrics_enabled = false
#         metric_name                = "friendly-rule-metric-name"
#         sampled_requests_enabled   = false
#       }
#     }
#   }
#   visibility_config {
#     cloudwatch_metrics_enabled = false
#     metric_name                = "friendly-metric-name"
#     sampled_requests_enabled   = false
#   }
# }
# IMPORT Resource
# resource "aws_s3_bucket" "legacy_resource" {
#   bucket = "website-origin-1564841523"
# }
