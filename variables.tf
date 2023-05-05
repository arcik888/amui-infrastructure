variable "aws_region" {
  description = "AS region of VPC"
  type        = string
}

variable "amui_instance_name" {
  type = list(string)
}

variable "amui_sql_replicas_number" {
  type = number
}

variable "vpc_name" {
  type = string
}

variable "vpc_short_name" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "general_cidr_block" {
  type = string
}

variable "bastion_ebs_size" {
  type = number
}

variable "sql_ebs_size" {
  type = number
}

variable "vpc_cidr_block" {
  type        = list(string)
  default = [
    "32.0.0.0/16",
    "32.0.1.0/24",
    "32.0.2.0/24",
    "32.0.3.0/24"
  ]

}