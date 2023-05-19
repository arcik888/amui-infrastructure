variable "aws_region" {
  description = "AS region of VPC"
  type        = string
}

variable "amui_instance_name" {
  type = list(string)
  default = [
  "SQL_master",
  "SQL_replica",
  ]
}

variable "amui_sql_replicas_number" {
  type = number
  default = 2
}

variable "vpc_name" {
  type = string
}

variable "vpc_short_name" {
  type = string

  validation {
    condition     = length(var.vpc_short_name) >= 3 && length(var.vpc_short_name) <= 4
    error_message = "The short name of the VPC must be 3 or 4 characters long"
  }
}

variable "general_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "sql_ebs_size" {
  type = number
}

variable "customer_full_name" {
  type = string
}

variable "customer_short_name" {
  type = string

  validation {
    condition     = length(var.customer_short_name) >= 3 && length(var.customer_short_name) <= 4
    error_message = "The short name of the Customer must be 3 or 4 characters long"
  }
}

variable "db_password" {
  sensitive = true
}