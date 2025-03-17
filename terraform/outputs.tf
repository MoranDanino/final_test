output "instance_ip" {
  value = aws_instance.builder.public_ip
}

output "instance_id" {
  value = aws_instance.builder.id
}

output "ami" {
  value = aws_instance.builder.ami
}

output "sg" {
  value = aws_security_group.moran_sg.id
}

output "ssh_path" {
  value = var.ssh_key_path
}