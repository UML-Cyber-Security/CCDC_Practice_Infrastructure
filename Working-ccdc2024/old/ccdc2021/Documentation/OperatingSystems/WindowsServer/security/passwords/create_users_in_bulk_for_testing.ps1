# this script is for testing purposes only
# it creates a bulk number of generic users in an active directory and places them under a particular organizational unit specified by the host
# it also creates the organizational unit itself, if needed

$username=Read-Host "Enter Root Name for Users"
$n=Read-Host "Enter Number of Users to Create"
$ou=Read-Host "Enter Organizational Unit"
$path="OU=" + $ou + ",DC=test,DC=net"
$count=1..$n

if(-not (Get-ADOrganizationalUnit -Filter "distinguishedName -eq '$path'")){
	New-ADOrganizationalUnit -Name $ou -ProtectedFromAccidentalDeletion $False
}
foreach ($i in $count)
{ New-ADUser -Name $username$i -Enabled $True -Path $path -ChangePasswordAtLogon $True `
-AccountPassword (ConvertTo-SecureString "cp92.Ls!Ir37Vv2\" -AsPlainText -force) -passThru}
