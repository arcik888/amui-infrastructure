output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.amui_vpc.id
}

output "public_subnet_ids" {
  description = "Value of Public Subnet ID in AMUI VPC"
  value = [ for subnet in aws_subnet.amui_public_subnet : subnet.id ]
}

output "amui_public_subnet_cidr" {
  value = [ for cidr  in aws_subnet.amui_public_subnet : cidr.cidr_block ]
}

output "private_subnet_ids" {
  description = "Value of Private Subnet ID in AMUI VPC"
  value = [ for subnet in aws_subnet.amui_private_subnet : subnet.id ]
}

output "amui_private_subnet_cidr" {
  value = [ for cidr  in aws_subnet.amui_private_subnet : cidr.cidr_block ]
}