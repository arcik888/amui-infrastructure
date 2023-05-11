
variable "amui_subnet_id" {
  description = "Subnet ID where instance belongs"
  type        = string
  default     = null
}

variable "amui_instance_name" {
  description = "Name of Instance"
  default     = null
}

variable "amui_instance_key" {
  description = "SSH key for Instance"
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security groups"
  default     = null
}

variable "ebs_size" {
  description = "Size of additional disk"
  default     = null
}

variable "customer_short" {
  default = null
}

variable "vpc_short" {
  default = null
}