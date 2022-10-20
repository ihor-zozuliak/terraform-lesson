variable "instance_type" {}
variable "server_count" {
  type        = number
  description = "Type numberl"
  default     = "1"
}
variable "enable_dns" {
  type        = bool
  description = "Type bool"
  default     = true
}

variable "sec_ips" {
  type        = list(string)
  description = "List of strings"
  default     = ["10.0.0.100", "10.0.0.200"]
}
variable "server_tags" {
  type        = map(string)
  description = "map_that_look_like_set of strings"
  default = {
    Name      = "Webserver"
    Owner     = "Avenga"
    Terraform = true
    ORGID     = 1684651
  }
}
variable "whitelisted_ips" {
  type = map(object({
    name        = string
    description = string
    addresses   = list(string)
    priority    = number
  }))
  default = {
    "apple" = {
      name        = "Apple"
      description = "Apple organisation VPN"
      addresses   = ["158.200.20.1/32", "1.2.3.3/32", "5.8.96.5/32"]
      priority    = 0
    }
    "microsoft" = {
      name        = "Microsoft"
      description = "Microsoft organisation VPN"
      addresses   = ["58.10.20.1/32", "1.49.3.3/32", "5.85.96.5/32"]
      priority    = 1
    }
    "google" = {
      name        = "Google"
      description = "Google organisation VPN"
      addresses   = ["8.110.210.15/32", "100.49.3.33/32", "57.85.96.5/32"]
      priority    = 2
    }
  }
  description = "Map object"
}
