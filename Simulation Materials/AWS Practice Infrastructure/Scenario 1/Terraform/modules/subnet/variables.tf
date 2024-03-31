variable "blueteam_vpc_id" {
  description = "The ID of the VPC in which the subnet will be created."
}

variable "blueteam_igw_id" {
  description = "The ID of the Internet Gateway to attach to the VPC."
}

variable "blueteam_vpc_public_subnet_cidr" {
  description = "The prefix of the public game subnet"
}

variable "blueteam_vpc_blackteam_subnet_cidr" {
  description = "The prefix of the blackteam subnet"
}

variable "blueteam_vpc_public_nat_subnet_cidr" {
  description = "The prefix of the public facing NAT subnet"
}