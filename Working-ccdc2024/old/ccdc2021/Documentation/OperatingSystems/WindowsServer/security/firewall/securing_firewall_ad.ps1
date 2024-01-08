# reset the firewall settings to the defaults
netsh advfirewall reset

# set both the inbound and outbound connections to block by default
netsh advfirewall set allprofiles firewallpolicy blockinbound,blockoutbound

# add new outbound firewall rules that are necessary for AD (only opening the necessary ports)
New-NetFirewallRule -DisplayName “W32Time (UDP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol UDP -LocalPort 123 
New-NetFirewallRule -DisplayName “RPC Endpoint Mapper (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 135 
New-NetFirewallRule -DisplayName “Kerberos password change (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 464 
New-NetFirewallRule -DisplayName “Kerberos password change (UDP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol UDP -LocalPort 464 
New-NetFirewallRule -DisplayName “RPC Dynamic Ports (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 49152-65535
New-NetFirewallRule -DisplayName “LDAP (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 389
New-NetFirewallRule -DisplayName “LDAP (UDP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol UDP -LocalPort 389
New-NetFirewallRule -DisplayName “LDAP SSL (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 636
New-NetFirewallRule -DisplayName “LDAP GC (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 3268
New-NetFirewallRule -DisplayName “LDAP GC SSL (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 3269
New-NetFirewallRule -DisplayName “DNS (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 53
New-NetFirewallRule -DisplayName “DNS (UDP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol UDP -LocalPort 53
New-NetFirewallRule -DisplayName “Kerberos (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 88
New-NetFirewallRule -DisplayName “Kerberos (UDP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol UDP -LocalPort 88
New-NetFirewallRule -DisplayName “SMB (TCP-out)” -Direction Outbound -Enabled True -Group “Active Directory” -Profile Any -Action Allow -Protocol TCP -LocalPort 445

# disable the unnecessary inbound firewall rules
Show-NetFirewallRule | where {($_.DisplayGroup -eq "Alljoyn Router" -or $_.DisplayGroup -eq "Cast to Device functionality" -or $_.DisplayGroup -eq "DIAL protocol server") -and $_.Direction -eq "Inbound"} 
| Disable-NetFirewallRule