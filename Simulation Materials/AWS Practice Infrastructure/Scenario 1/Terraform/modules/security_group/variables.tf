locals {
    CR-VPN-Pub-IP = ""    # Cyber Range VPN Public IP address. Find and populate it.
}

variable "blueteam_vpc_id" {
  description = "The ID of the VPC in which the security group will be created."
}

variable "blueteam_vpc_cidr" {
  description = "The entire VPC CIDR range"
}

variable "blueteam_vpc_blackteam_subnet_cidr" {
  description = "The blackteam's subnet"
}