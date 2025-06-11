#Public subnet
resource "aws_subnet" "practice_pub_subnet" {
    vpc_id = var.vpc_id
}

variable "vpc_id" {
    # place holder for vpc id output
    # required for output
}

output "practice_pub_subnet_id" {
    value = aws_subnet.practice_pub_subnet
}