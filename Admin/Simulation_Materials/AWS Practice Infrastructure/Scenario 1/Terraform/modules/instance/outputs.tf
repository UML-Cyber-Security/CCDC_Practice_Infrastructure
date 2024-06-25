output "Windows_Instances" {
    value = aws_instance.windows_instances
}

output "Linux_Ubuntu_Instances" {
    value = aws_instance.linux_ubuntu_instances
}

output "Linux_RHEL_Instances" {
    value = aws_instance.linux_rhel_instances
}

output "Wireguard_Server_Instance" {
    value = aws_instance.wireguard_server_instance
}

output "Wireguard_EIP" {
    value = aws_eip.wireguard_eip
}