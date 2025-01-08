# Disable all domain user accounts except specified exclusions

# If ActiveDirectory module isn't loaded, try to import it
$ActiveDirectoryModuleAvailable = $true
if (-not (Get-Module -Name ActiveDirectory -ErrorAction SilentlyContinue)) {
    try {
        Import-Module ActiveDirectory
    } catch {
        Write-Warning "Failed to import ActiveDirectory module. Make sure it's installed."
        $ActiveDirectoryModuleAvailable = $false
    }
}

# Disable AD accounts, if ActiveDirectory module is available
if ($ActiveDirectoryModuleAvailable) {
    # Current user and excluded accounts
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $excludedAccounts = @("black team") # Add any other accounts to this array if needed

    try {
        Get-ADUser -Filter * | 
        Where-Object { $_.SamAccountName -ne $currentUser.Split('\')[1] -and $excludedAccounts -notcontains $_.SamAccountName } | 
        ForEach-Object {
            $username = $_.SamAccountName
            Disable-ADAccount -Identity $username
            Write-Host "Disabled AD account: $username"
        }
    } catch {
        Write-Warning "Failed to disable AD accounts. Make sure you have the necessary permissions."
    }
}
