# this script is for testing purposes only
# it deletes all of the users under a particular organizational unit specified by the host
# it also deletes the organizational unit itself when finished

$ou = Read-Host "Enter Organizational Unit"
$path = "OU=" + $ou + ",DC=test,DC=net"

Get-ADUser -Filter * -SearchBase ($path) `
| Remove-ADUser -Confirm:$False

Remove-ADOrganizationalUnit $path -Confirm:$False
