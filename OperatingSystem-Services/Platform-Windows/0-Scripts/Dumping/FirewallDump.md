# Define the path to the output files in the user's Documents directory
$basePath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "Dump")
if (!(Test-Path -Path $basePath)) {
    New-Item -ItemType Directory -Force -Path $basePath
}

# Function to export firewall rules based on the profile
function Export-FirewallRules {
    param (
        [string]$profile
    )

    $outputFile = Join-Path $basePath "FirewallRules_$profile.txt"
    Get-NetFirewallRule -Enabled True -Profile $profile | Format-Table -Property DisplayName, Action, Direction, Profile, Enabled, Group, LocalPort, RemotePort, Protocol | Out-File -FilePath $outputFile
    Write-Host "Exported firewall rules for $profile profile to $outputFile"
}

# Export firewall rules for each profile
Export-FirewallRules -profile "Domain"
Export-FirewallRules -profile "Private"
Export-FirewallRules -profile "Public"

# Confirmation message
Write-Host "Firewall rule information exported to $basePath"