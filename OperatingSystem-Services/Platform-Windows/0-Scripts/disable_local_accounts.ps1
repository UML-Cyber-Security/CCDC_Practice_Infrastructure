# Disable all local user accounts except specified exclusions

# Current user and excluded accounts
$currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
$excludedAccounts = @("black team") # Add any other accounts to this array if needed

# Disable local accounts
Get-WmiObject -Class Win32_UserAccount -Filter "LocalAccount='True'" | 
Where-Object { $_.Name -ne $currentUser.Split('\')[1] -and $excludedAccounts -notcontains $_.Name } | 
ForEach-Object {
    $username = $_.Name
    net user $username /active:no
    Write-Host "Disabled local account: $username"
}
