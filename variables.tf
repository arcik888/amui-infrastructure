variable "awsRegion" {
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

variable "vpcName" {
  type = string
}

variable "vpcShortName" {
  type = string

  validation {
    condition     = length(var.vpcShortName) >= 3 && length(var.vpcShortName) <= 4
    error_message = "The short name of the VPC must be 3 or 4 characters long"
  }
}

variable "general_cidr_block" {
  type    = string
  default = "0.0.0.0/0"
}

variable "sqlEbsSize" {
  type = number
}

variable "customerFullName" {
  type = string
}

variable "customerShortName" {
  type = string

  validation {
    condition     = length(var.customerShortName) >= 3 && length(var.customerShortName) <= 4
    error_message = "The short name of the Customer must be 3 or 4 characters long"
  }
}

variable "db_password" {
  sensitive = true
}

variable "instance_key" {
  description = "SSH key to access instances"
  sensitive = true
}