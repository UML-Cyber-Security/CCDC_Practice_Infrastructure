# this script force changes the passwords for all user accounts in an active directory underneath a particular organizational unit specified by the host
# it also forces these users to change their passwords before they log in next
# created specifically for handling a large number of default/blank user accounts to quickly secure them

$password = "tbM=eYT3u&nEz@^f"
$ou = Read-Host "Enter Organizational Unit"
$path = "OU=" + $ou + ",DC=test,DC=net"

Get-ADUser -Filter * -SearchBase ($path) `
| Set-ADAccountPassword -reset -newpassword (ConvertTo-SecureString -AsPlainText $password -Force) -PassThru `
| Set-ADUser -ChangePasswordAtLogon $True
