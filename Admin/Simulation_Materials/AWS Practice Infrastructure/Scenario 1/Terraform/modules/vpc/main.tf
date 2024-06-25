#####################################
# VPC Creation <--
#   \ - Subnet creation
#   \ - Internet gateway creation (Main one)
#   \ - Routing table creation
#       \ - Public subnet 
#   \ - Create appropriate security groups 
#       \ - Public subnet
#####################################

# Create a new VPC for the blueteam
# Denote the CIDR block that the VPC uses.
resource "aws_vpc" "blueteam_vpc" {
    cidr_block = var.blueteam_vpc_cidr
}

#####################################
# VPC Creation
#   \ - Subnet creation
#   \ - Internet gateway creation (Main one) <--
#   \ - Routing table creation
#       \ - Public subnet
#   \ - Create appropriate security groups 
#       \ - Public subnet
#####################################

# Attach an internet gateway to the VPC created above.
resource "aws_internet_gateway" "blueteam_igw" {
    vpc_id = aws_vpc.blueteam_vpc.id
}

