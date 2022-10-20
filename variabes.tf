variable "subnet_cidr" {
  type        = string
  description = "String var"
  default     = "10.0.0.0/24"
}
variable "server_count" {
  type        = number
  description = "Number var"
  default     = "1"
}
variable "enabled" {
  type        = bool
  description = "Bool var"
  default     = true
}
variable "secondary_ips" {
  type        = list(string)
  description = "List of strings var"
  default     = ["10.0.0.100", "10.0.0.200"]
}
variable "waf_ips" {
  type = map(object({
    name        = string
    description = string
    ips         = list(string)
  }))
  default = {
    "us" = {
      name        = "usa"
      description = "USA offices VPN"
      ips         = ["12.45.221.10/32", "95.48.201.100/32"]
    }
    "eu" = {
      name        = "eu"
      description = "Europe offices VPN"
      ips         = ["11.56.101.10/32", "213.25.100.100/32"]
    }
  }
}
