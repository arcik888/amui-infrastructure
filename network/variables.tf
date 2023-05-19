variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = list(string)
  default = [
    "32.0.0.0/16",
    "32.0.1.0/24",
    "32.0.2.0/24",
    "32.0.3.0/24"
  ]
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = null # "develpoment"
}

variable "vpc_short_name" {
  description = "Abbreviation of full name"
  type        = string
  default     = null # "dev"
}

variable "azs" {
  description = "Availability zones of VPC"
  type        = list(string)
  default = [
    "eu-central-1a",
    "eu-central-1b",
  ]
}

variable "general_cidr_block" {
  description = "CIDR block for general purpouse - all internet connection"
  type        = string
  default     = "0.0.0.0/0"
}

variable "customer_short" {
  type    = string
  default = null
}