variable "amui_private_subnet_1" {
  description = "Private Subnet 1"
  default     = null
}

variable "amui_private_subnet_2" {
  description = "Private Subnet 2"
  default     = null
}

variable "amui_db_sg_1" {
  description = "Database Security Group"
  default     = null
}

variable "customer_short" {
  description = "Customer's short name"
  default     = null
}

variable "vpc_short" {
  default = null
}

variable "db_password" {
  type = string
  sensitive = true
}