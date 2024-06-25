# Specify region that AWS will use.
provider "aws" {
    region = "us-west-2" # Oregon
}

module "vpc" {
    source = "./modules/vpc"

    blueteam_vpc_cidr = local.blueteam_vpc_cidr
}

module "subnet" {
    source = "./modules/subnet"

    # These need to match with the variables in the subnet module
    blueteam_vpc_id = module.vpc.blueteam_vpc.id
    blueteam_igw_id = module.vpc.blueteam_igw.id
    blueteam_vpc_public_subnet_cidr = local.blueteam_vpc_public_subnet_cidr
    blueteam_vpc_public_nat_subnet_cidr = local.blueteam_vpc_public_nat_subnet_cidr
    blueteam_vpc_blackteam_subnet_cidr = local.blueteam_vpc_blackteam_subnet_cidr
}

module "security_group" {
    source = "./modules/security_group"
    
    # These need to match with the variables in the security_group module
    blueteam_vpc_id = module.vpc.blueteam_vpc.id
    blueteam_vpc_cidr = local.blueteam_vpc_cidr
    blueteam_vpc_blackteam_subnet_cidr = local.blueteam_vpc_blackteam_subnet_cidr
}

module "instance" {
    source = "./modules/instance"
    depends_on = [ module.vpc, module.subnet, module.security_group ]

    blueteam_vpc_id                 = module.vpc.blueteam_vpc.id

    public_subnet_id                = module.subnet.public_subnet.id
    vpn_subnet_id                   = module.subnet.vpn_subnet.id

    DNT_BT_VPN_Connectivity_id      = module.security_group.DNT_BT_VPN_Connectivity.id
    allow_all_id                    = module.security_group.allow_all.id
    wireguard_access_sg_id          = module.security_group.wireguard_access_sg.id
    allow_all_vpc_id                = module.security_group.allow_all_vpc.id
}
