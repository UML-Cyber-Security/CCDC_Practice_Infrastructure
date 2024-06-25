# NOTE: the value is private_public because
# the true public value is the NAT subnet
# but only the NAT gateway is hiding in there.
output public_subnet {
    value = aws_subnet.public_subnet
}

output vpn_subnet {
    value = aws_subnet.vpn_subnet
}