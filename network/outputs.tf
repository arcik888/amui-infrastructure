output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.amui_vpc.id
}

output "public_subnet_ids" {
  description = "Value of Public Subnet ID in AMUI VPC"
  value = [ for subnet_id in aws_subnet.amui_public_subnet : subnet_id ]
}

output "private_subnet_id" {
  description = "Value of Private Subnet 1 ID in AMUI VPC"
  value = [ for subnet_id in aws_subnet.amui_private_subnet : subnet_id ]
}
