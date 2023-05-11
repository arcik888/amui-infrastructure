output "amui_vpc_id" {
  description = "ID of created VPC"
  value       = module.amui_vpc.vpc_id
}

output "amui_public_subnet_id" {
  description = "Value of Public Subnet ID in AMUI VPC"
  value       = module.amui_vpc.public_subnet_id
}

output "amui_private_subnet_1_id" {
  description = "Value of Private Subnet 1 ID in AMUI VPC"
  value       = module.amui_vpc.private_subnet_1_id
}

output "amui_private_subnet_2_id" {
  description = "Value of Private Subnet 2 ID in AMUI VPC"
  value       = module.amui_vpc.private_subnet_2_id
}

output "amui_elastic_ip" {
  description = "IP address of NAT gateway"
  value       = module.amui_vpc.elastic_ip
}

output "amui_bastion_id" {
  description = "ID of the Bastion instance"
  value       = module.amui_instance_bastion.instance_id
}

output "amui_instance_sql_master_private_ip" {
  value = module.amui_instance_sql_master.instance_private_ip
}

output "amui_instance_sql_replica_private_ip" {
  value = ["${module.amui_instance_sql_replica.*.instance_private_ip}"]
}

output "amui_bastion_public_ip" {
  value = module.amui_instance_bastion.instance_public_ip
}

output "amui_infratools_instance_private_ip" {
  value = module.infratools.instance_private_ip
}

output "bastion_url" {
  value = module.amui_instance_bastion.instance_url
}

output "connection_string" {
  value = "ssh -A -i '~/.ssh/instance_key' admin@${module.amui_instance_bastion.instance_url}"
}

output "rds_arn" {
  value = module.amui_rds.db_name
}