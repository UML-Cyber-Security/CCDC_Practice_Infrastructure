# Check if ActiveDirectory module is available
if (Get-Module -ListAvailable -Name ActiveDirectory) {
        # Import the Active Directory module
        Import-Module ActiveDirectory

        # Get all disabled users
        $disabledUsers = Get-ADUser -Filter 'Enabled -eq $false' | Select-Object -ExpandProperty SamAccountName

        # For each disabled user
        foreach ($user in $disabledUsers) {
                # Get the session ID of the user
                $sessionId = ((quser | Where-Object { $_ -match $user }) -split ' +')[2]
                
                # If the session ID exists, log off the user
                if ($sessionId) {
                        logoff $sessionId
                }
        }
}
    
# Get all local users
$localUsers = Get-LocalUser

# For each local user
foreach ($user in $localUsers) {
        # If the user is disabled
        if ($user.Enabled -eq $false) {
                # Get the session ID of the user
                $sessionId = ((quser | Where-Object { $_ -match $user.Name }) -split ' +')[2]
                
                # If the session ID exists, log off the user
                if ($sessionId) {
                        logoff $sessionId
                }
        }
}
    
