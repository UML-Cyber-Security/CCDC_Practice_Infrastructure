# Disables all GPO Policies not made by the system

# Define a function to set the GPO status
function SetGPOStatus([string]$GPOName, [string]$Status) {
        $gpo = Get-GPO $GPOName -ErrorAction SilentlyContinue
        if ($null -eq $gpo) {
            Write-Host "Could not locate $GPOName"
        }
        else {
            $gpo.GpoStatus = $Status
            Write-Host "Set $($gpo.DisplayName) to $($gpo.GpoStatus)"
        }
    }
    
# Microsoft module to manage Group Policy
Import-Module grouppolicy

# Identify the well-known system SID for comparison
$systemSID = (New-Object System.Security.Principal.SecurityIdentifier "S-1-5-18").Value

# Get all GPOs in the domain
$allGPOs = Get-GPO -All

# Loop through each GPO
foreach ($gpo in $allGPOs) {
        # Get the owner of the GPO
        $gpoSecurityInfo = Get-GPOReport -Name $gpo.DisplayName -ReportType xml
        $gpoOwnerSID = ([xml]$gpoSecurityInfo).GPO.SecurityDescriptor.Owner.SID

        # If the GPO owner is not the system, then disable the GPO
        if ($gpoOwnerSID -ne $systemSID) {
                SetGPOStatus $gpo.DisplayName "AllSettingsDisabled"
        }
}

# Block GPO inheritance for all OUs. This is a more aggressive action.
# $allOUs = Get-ADOrganizationalUnit -Filter '*'
# foreach ($ou in $allOUs) {
#         Set-GPInheritance -Target $ou.DistinguishedName -IsBlocked $true
#         Write-Output "Blocked GPO inheritance for OU: $($ou.Name)"
# }
