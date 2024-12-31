resource "aws_instance" "my_vm" {
  count         = 4
  ami           = "ami-0866a3c8686eaeeba" //Ubuntu AMI
  instance_type = var.instance_type
  tags = {
    Name = "Ubuntu-Machine-${count.index}",
  }
  subnet_id = aws_subnet.practice_priv_subnet.id
}

resource "aws_instance" "rh_linux" {
  count         = 3
  ami           = "ami-0583d8c7a9c35822c"
  instance_type = var.instance_type

  tags = {
    Name = "Red-hat-linux-Machine-${count.index}"
  }
  subnet_id = aws_subnet.practice_priv_subnet.id
}

resource "aws_instance" "windows-machine" {
  count         = 6
  ami           = "ami-073e3b46f8802d31b"
  instance_type = var.instance_type
  tags = {
    Name = "windows-machine-${count.index}"
  }
  subnet_id = aws_subnet.practice_priv_subnet.id
}



resource "aws_vpc" "practice_vpc" {
  cidr_block = var.vpc_cidr #"10.0.0.0/16"
  tags = {
    Name = "Blueteam practice VPC"
  }
}
# VPC auto creates a 
# - default route table(which has no internet)
# allows communitcation internally



resource "aws_subnet" "practice_pub_subnet" {
  vpc_id                  = aws_vpc.practice_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
}

resource "aws_subnet" "practice_priv_subnet" {
  vpc_id     = aws_vpc.practice_vpc.id
  cidr_block = var.private_subnet_cidr
}

# set up internet gateway for public subnets
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.practice_vpc.id
  tags = {
    Name = "practice_pub_igw"
  }
}

# To make the subnets named “Public” public, we have to create routes using IGW which will enable the traffic from the Internet to access these subnets.
# Subnets are private by default
# We need to create a second route table for the public subnet to reacht the internet
# route table for public subnet
resource "aws_route_table" "practice_second_rt" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "2nd route table"
  }
}

# Associate public subnets w/ the 2nd route table
resource "aws_route_table_association" "practice_public_subnet_assoc" {
  count          = 1
  subnet_id      = aws_subnet.practice_pub_subnet.id
  route_table_id = aws_route_table.practice_second_rt.id
}


# Nat gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

# creates the nat gateway
resource "aws_nat_gateway" "practice_nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.practice_pub_subnet.id
}

# route table for nat gateway
resource "aws_route_table" "practice_private_route_table" {
  vpc_id = aws_vpc.practice_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.practice_nat_gateway.id
  }
}

# Associate the nat gateway with the private subnet
resource "aws_route_table_association" "practice_private_subnet_association" {
  subnet_id      = aws_subnet.practice_priv_subnet.id
  route_table_id = aws_route_table.practice_private_route_table.id

}


######
## Wireguard Configs
######

# Security Group for VPN to allow traffic
resource "aws_security_group" "practice_wireguard_sg" {
  vpc_id = aws_vpc.practice_vpc.id
  ingress {
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # Allow traffic to WireGuard on the public internet
  }
  # SSH itself doesn’t operate over port 51820. Instead, port 51820 is set up to handle WireGuard VPN traffic. The idea is to use WireGuard as a secure VPN tunnel to access the private network, including the EC2 instance, as if you were on the same internal network.
  # Here’s how it works:
  # Connect to WireGuard: You connect to your EC2 instance using the WireGuard client on your machine. This creates a secure tunnel to the EC2 instance via port 51820.
  # SSH over the VPN: Once connected through WireGuard, your machine will have an internal IP within the VPN network, allowing you to SSH to the instance using its private IP over port 22. The SSH traffic will be routed securely over the VPN.

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "practice_wireguard_server" {
  ami             = "ami-0866a3c8686eaeeba"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.practice_pub_subnet.id
  security_groups = [aws_security_group.practice_wireguard_sg.id]
  # Install WireGuard and set up server configuration
  # we use anisible to install wireguard docker easy
  key_name = aws_key_pair.chisom_keypair.key_name
  tags = {
    Name = "WireGuard Server"
  }
}
### ssh key
# aws prefers rsa keys, personal experience
# ecdsa was prompted w/ errors
resource "aws_key_pair" "chisom_keypair" {
  key_name = var.pub_key_name
  public_key = var.pub_key_pair
}


output "ec2_ip" {
  value = aws_instance.practice_wireguard_server.public_ip

}

output "rh_linux_priv_ip" {
  value = [for i in aws_instance.rh_linux : i.private_ip]
}

output "rh_linux_public_ip" {
  value = [for i in aws_instance.rh_linux : i.public_ip]
}
output "windows_private_ips" {
  value = [for i in aws_instance.windows-machine : i.private_ip]
}

output "windows_pub_ips" {
  value = [for i in aws_instance.windows-machine : i.public_ip]
}

resource "aws_eip" "wireguard_eip" {
  vpc      = true
  instance = aws_instance.practice_wireguard_server.id
}



