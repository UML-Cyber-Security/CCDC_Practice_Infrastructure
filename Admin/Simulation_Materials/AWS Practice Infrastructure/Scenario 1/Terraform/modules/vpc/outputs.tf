output "blueteam_igw" {
    value = aws_internet_gateway.blueteam_igw
}

output "blueteam_vpc" {
    value = aws_vpc.blueteam_vpc
}

output "blueteam_vpc_cidr" {
    value = var.blueteam_vpc_cidr
}