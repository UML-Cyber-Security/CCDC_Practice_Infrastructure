#####################################
# VPC Creation
#   \ - Subnet creation <--
#   \ - Internet gateway creation (Main one)
#   \ - Routing table creation
#       \ - Public subnet
#   \ - Create appropriate security groups 
#       \ - Public subnet 
#####################################

resource "aws_subnet" "public_subnet" {
    vpc_id = var.blueteam_vpc_id
    cidr_block = var.blueteam_vpc_public_subnet_cidr
    availability_zone = "us-west-2b"

    tags = {
        Name = "RP-Game-Subnet"
    }
}
# Create the route table for the public subnet.
# NOTE: It's not associated yet. We need to
# essentially "attach" it to the subnet 
resource "aws_route_table" "public_route_table" {
    vpc_id = var.blueteam_vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.public_nat_gateway.id
    }

    tags = {
        Name = "RP-Game-Subnet-Route-Table"
    }
}

# Now, associate the public route table with the public subnet
resource "aws_route_table_association" "public_subnet_association" {
    subnet_id       = aws_subnet.public_subnet.id
    route_table_id  = aws_route_table.public_route_table.id
}


#####################################
# VPC Creation
#   \ - Subnet creation
#   \ - Internet gateway creation (Main one)
#   \ - Routing table creation
#       \ - Public subnet <--
#   \ - Create appropriate security groups 
#       \ - Public subnet 
#####################################

# Create a public subnet within the VPC above
# Has the CIDR notated 
# Stored within the availability zone provided.
resource "aws_subnet" "public_nat_subnet" {
    vpc_id              = var.blueteam_vpc_id
    cidr_block          = var.blueteam_vpc_public_nat_subnet_cidr
    availability_zone   = "us-west-2a"

    tags = {
        Name = "RP-NAT Subnet"
    }
}

# Setup an Elastic IP (static public IP)
# for the NAT Gateway that will be placed
# in the public subnet.
resource "aws_eip" "public_nat_subnet_eip" {
    vpc = true

    tags = {
        Name = "Public Subnet NAT Gateway EIP"
    }
}



# Setup a NAT gateway in the public subnet
# for use by the private subnet to route
# internet traffic through.
resource "aws_nat_gateway" "public_nat_gateway" {
    allocation_id   = aws_eip.public_nat_subnet_eip.id
    subnet_id       = aws_subnet.public_nat_subnet.id
    tags = {
        Name = "Public Subnet NAT Gateway"
    }
}

# Create the route table for the public subnet.
# NOTE: It's not associated yet. We need to
# essentially "attach" it to the subnet 
resource "aws_route_table" "public_nat_route_table" {
    vpc_id = var.blueteam_vpc_id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = var.blueteam_igw_id
    }

    tags = {
        Name = "Public Route Table"
    }
}

# Now, associate the public route table with the public subnet
resource "aws_route_table_association" "public_nat_subnet_association" {
    subnet_id       = aws_subnet.public_nat_subnet.id
    route_table_id  = aws_route_table.public_nat_route_table.id
}

# ##################################
#
# # wireguard Server Configuration
#
# ##################################

##########################################
# Create a subnet for the wireguard server
##########################################
resource "aws_subnet" "vpn_subnet" {
    vpc_id              = var.blueteam_vpc_id
    cidr_block          = var.blueteam_vpc_blackteam_subnet_cidr
    availability_zone   = "us-west-2a"

    tags = {
        Name = "DNT-BT-VPN-Subnet"
    } 
}


##############################################
# Update the route table of the VPN subnet
##############################################
resource "aws_route_table" "vpn_subnet_route_table" {
    vpc_id = var.blueteam_vpc_id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id = var.blueteam_igw_id
    }

    tags = {
        Name = "DNT-BT-VPN-Subnet-Route-Table"
    }
}


resource "aws_route_table_association" "vpn_subnet_association" {
    subnet_id       = aws_subnet.vpn_subnet.id
    route_table_id  = aws_route_table.vpn_subnet_route_table.id
}