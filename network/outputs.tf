output "vpc_id" {
  description = "ID of created VPC"
  value       = aws_vpc.amui_vpc.id
}

output "public_subnet_id" {
  description = "Value of Public Subnet ID in AMUI VPC"
  value       = aws_subnet.amui_public_subnet_1.id
}

output "private_subnet_1_id" {
  description = "Value of Private Subnet 1 ID in AMUI VPC"
  value       = aws_subnet.amui_private_subnet_1.id
}

output "private_subnet_2_id" {
  description = "Value of Private Subnet 2 ID in AMUI VPC"
  value       = aws_subnet.amui_private_subnet_2.id
}

output "elastic_ip" {
  description = "IP address of NAT gateway"
  value       = aws_eip.amui_nat_eip.public_ip
}