#################################
# All outputs for modules
#################################
output "blueteam_vpc_id" {
  value = module.vpc.blueteam_vpc.id
}

output "blueteam_igw_id" {
  value = module.vpc.blueteam_igw.id
}

output "public_subnet_id" {
  value = module.subnet.public_subnet.id
}

output "vpn_subnet_id" {
  value = module.subnet.vpn_subnet.id
}

output "DNT_BT_VPN_Connectivity_id" {
  value = module.security_group.DNT_BT_VPN_Connectivity.id
}

output "allow_all_id" {
  value = module.security_group.allow_all.id
}

output "wireguard_access_sg_id" {
  value = module.security_group.wireguard_access_sg.id
}

output "allow_all_vpc_id" {
  value = module.security_group.allow_all_vpc.id
}

#################################
# All instance outputs
#################################
output "Windows_Instances"{
  value = module.instance.Windows_Instances
}

output "Linux_Ubuntu_Instances"{
  value = module.instance.Linux_Ubuntu_Instances
}

output "Linux_RHEL_Instances"{
  value = module.instance.Linux_RHEL_Instances
}

#################################
# Blackteam outputs
#################################
output "Wireguard_Server_Instance" {
  value = module.instance.Wireguard_Server_Instance
}

output "Wireguard_EIP" {
  value = module.instance.Wireguard_EIP
}