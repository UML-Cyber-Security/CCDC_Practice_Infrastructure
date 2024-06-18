output "aws_instance_ip_zero" {
  value = aws_instance.web[0].public_ip
}

output "aws_instance_ip_one" {
  value = aws_instance.web[1].public_ip
}
