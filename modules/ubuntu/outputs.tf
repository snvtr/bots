output "ubuntu_ip" {
  description = "ubuntu ip"
  value       = aws_instance.ubuntu.private_ip
}
