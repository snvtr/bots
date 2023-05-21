output "instance_ip" {
  description = "instance ip"
  value       = aws_instance.instance.private_ip
}
