#import bulk users from a .csv file for testing
#header row for .csv file is on the next line
#password,detailedname,first,last

$Users = Import-Csv -Delimiter "," -Path ".\users.csv"
foreach ($User in $Users)
{
  $OU = "OU=Accounts,DC=riversbend,DC=org"
  New-AdUser -Name $User.detailedname -SamAccountName $User.detailedname -UserPrincipalName $User.detailname -displayname $User.detailedname `
  -GivenName $User.first -Surname $User.last -AccountPassword (ConvertTo-SecureString $User.password -AsPlainTest -Force) -Enabled $true `
  -Path $OU
}
