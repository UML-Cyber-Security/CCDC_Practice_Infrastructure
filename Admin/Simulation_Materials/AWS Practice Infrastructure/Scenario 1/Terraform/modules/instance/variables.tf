locals {
    # Custom AMIs located within Oregon (us-west-2) region
    ubuntu-ami = "ami-04adfcaab0735c306"   # Custom Ubuntu Base Image
    windows-ami = "ami-02142edf90af2aeb4"  # Custom Windows Server 2019 Image
    rhel-ami = "ami-0b75c87ed13a14d36"     # Custom RHEL 9 Image
    wireguard-ami = "ami-0b80efc31c23a88df"

    type = "t2.small"
    blackteam_key = "AWS-CCDC-Blackteam"
    
    # Number of Instances to deploy
    num_ubuntu = 5
    num_rhel = 3
    num_windows = 6
}

variable "blueteam_vpc_id" {
  description = "The ID of the VPC in which the security group will be created."
}

variable "public_subnet_id" {
  description = "The ID of the public subnet in which the security group will be created."
}

variable "DNT_BT_VPN_Connectivity_id" {
  description = "The ID of the security group for VPN connectivity."
}

variable "allow_all_id" {
  description = "The ID of the security group for allowing all traffic."
}

variable "wireguard_access_sg_id" {
  description = "The ID of the security group for wireguard access."
}

variable "allow_all_vpc_id" {
  description = "The ID of the security group for allowing all traffic from instances within the VPC."
}

variable "vpn_subnet_id" {
  description = "The ID of the subnet for the wireguard server."
}













