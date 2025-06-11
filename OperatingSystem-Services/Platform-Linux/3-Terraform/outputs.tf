output "ec2_machines" {
  # Here * indicates that there are more than one arn because count is 4   
  value = aws_instance.my_vm.*.arn
}