output "instance_id" {
  description = "ID of 3the created instnce"
  value       = aws_instance.master.id
}

output "instance_private_ip" {
  description = "Private IP of instance"
  value       = aws_instance.master.private_ip
}
