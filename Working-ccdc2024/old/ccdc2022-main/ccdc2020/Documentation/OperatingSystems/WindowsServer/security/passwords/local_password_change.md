# Disable all local user accounts except admin

Get-LocalUser | Where-Object { $_ -NotLike "Administrator" } | ForEach-Object { Disable-LocalUser $_ }
 
# Change all local user accounts passswords

$Password = Read-Host -AsSecureString

Get-LocalUser | Set-LocalUser -Password $Password
