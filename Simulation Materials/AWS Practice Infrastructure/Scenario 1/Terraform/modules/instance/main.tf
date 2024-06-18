#####################################
# EC2 Machines for practice
#####################################
resource "aws_instance" "linux_ubuntu_instances" {
    count           = local.num_ubuntu
    ami             = local.ubuntu-ami
    instance_type   = local.type
    
    subnet_id       = var.public_subnet_id
    security_groups = [
                        var.allow_all_id,
                        var.DNT_BT_VPN_Connectivity_id
                      ]

    key_name        = local.blackteam_key
    

    tags = {
      Name = "M-${count.index+1}",
      OS = "Ubuntu"
    }
}

resource "aws_instance" "linux_rhel_instances" {
    count           = local.num_rhel
    ami             = local.rhel-ami
    instance_type   = local.type

    subnet_id       = var.public_subnet_id
    security_groups = [
                        var.allow_all_id,
                        var.DNT_BT_VPN_Connectivity_id
                      ]

    key_name        = local.blackteam_key
    

    tags = {
      Name = "M-${count.index + local.num_ubuntu + 1}",
      OS = "RHEL"
    }
}

resource "aws_instance" "windows_instances" {
    count           = local.num_windows
    ami             = local.windows-ami
    instance_type   = local.type
    
    subnet_id       = var.public_subnet_id
    security_groups = [
                        var.allow_all_id,
                        var.DNT_BT_VPN_Connectivity_id
                      ]

    key_name        = local.blackteam_key

    tags = {
      Name = "M-${count.index + local.num_ubuntu + local.num_rhel + 1}",
      OS = "Windows"
    }
}

#########################################
# Create the Wireguard server instance
#########################################
resource "aws_instance" "wireguard_server_instance" {
    ami             = local.wireguard-ami
    instance_type   = local.type
    subnet_id       = var.vpn_subnet_id

    security_groups =   [ 
                            var.allow_all_vpc_id, 
                            var.wireguard_access_sg_id
                        ]
    key_name        = local.blackteam_key
    

    tags = {
      Name = "DNT-BT-Public-Wireguard-Server",
      OS = "Ubuntu"
    }
}


# Create and associate an EIP for the wireguard server
resource "aws_eip" "wireguard_eip" {
    instance = aws_instance.wireguard_server_instance.id
}