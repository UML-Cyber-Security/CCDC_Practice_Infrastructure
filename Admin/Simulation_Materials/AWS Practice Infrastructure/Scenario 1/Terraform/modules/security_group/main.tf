
#####################################
# VPC Creation
#   \ - Subnet creation
#   \ - Internet gateway creation (Main one)
#   \ - Routing table creation
#       \ - Public subnet
#   \ - Create appropriate security groups 
#       \ - Public subnet <--
#####################################

resource "aws_security_group" "allow_all" {
    vpc_id = var.blueteam_vpc_id

    # Allow all outbound traffic from EC2 instances using
    # any protocol on any port to go to any destination.
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all inbound TCP traffic using any protocol 
    # on any port from any source IP.
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all inbound UDP traffic.
    ingress {
        from_port = 0
        to_port = 65535
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    # Allow all inbound ICMP from any source IP
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "S1"
    }
}

##################################
#
# wireguard Server Configuration
#
##################################


##################################
# wireguard Server Security Group
##################################

resource "aws_security_group" "wireguard_access_sg" {
    name        = "DNT-BT-Wireguard-access-sg"
    description = "Security group for Wireguard access"

    vpc_id = var.blueteam_vpc_id


    ingress {
        from_port = 51820
        to_port = 51820
        protocol = "udp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 51821
        to_port = 51821
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [local.CR-VPN-Pub-IP]
    }
}

#####################################################
# Wireguard server allow traffic from the VPC subnets
#####################################################
resource "aws_security_group" "allow_all_vpc" {
  name        = "DNT-BT-allow-all-vpc"
  description = "Allow all traffic from instances within the VPC to the Wireguard server."
  vpc_id      = var.blueteam_vpc_id


    # Allow traffic from instances within the VPC
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.blueteam_vpc_cidr] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#####################################################
# Allow traffic from the VPN subnet
#####################################################
resource "aws_security_group" "DNT_BT_VPN_Connectivity" {
    name            = "DNT-BT-VPN-Connectivity"
    description     = "Do not touch this. It allows traffic from the VPN subnet."
    vpc_id          = var.blueteam_vpc_id
    
    # Allow all traffic from the wireguard subnet
    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.blueteam_vpc_blackteam_subnet_cidr]
    }
}