output "DNT_BT_VPN_Connectivity" {
    value = aws_security_group.DNT_BT_VPN_Connectivity
}

output "wireguard_access_sg" {
    value = aws_security_group.wireguard_access_sg
}

output "allow_all_vpc" {
    value = aws_security_group.allow_all_vpc
}

output "allow_all" {
    value = aws_security_group.allow_all
}