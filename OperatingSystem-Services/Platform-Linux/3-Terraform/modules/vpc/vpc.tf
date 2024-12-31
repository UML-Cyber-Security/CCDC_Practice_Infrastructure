resource "aws_vpc" "practice_pub_vpc" {
    cidr_block = var.vpc_cidr_block
    tags = {
        name = "practice_vpc"
    }
}

output "vpc_id" {
    value = aws_vpc.practice_pub_vpc

}
output "vpc_cidr" {
    value = var.vpc_cidr_block
}