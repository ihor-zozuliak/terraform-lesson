variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "az" {}
variable "enable_dns" {
  type        = bool
  description = "Type bool"
  default     = true
}
