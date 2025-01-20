# Define paths for output files in the user's Documents directory
$basePath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "Dump")
if (!(Test-Path -Path $basePath)) {
    New-Item -ItemType Directory -Force -Path $basePath
}

# Function to export AD domain configuration
function Export-ADConfiguration {
    # Export domain information
    Get-ADDomain | Export-Clixml -Path "$basePath\DomainConfig.xml"

    # Export organizational units
    Get-ADOrganizationalUnit -Filter * | Export-Clixml -Path "$basePath\OrganizationalUnits.xml"

    # Export users
    Get-ADUser -Filter * | Export-Clixml -Path "$basePath\Users.xml"

    # Export groups
    Get-ADGroup -Filter * | Export-Clixml -Path "$basePath\Groups.xml"

    # Export GPOs
    Get-GPO -All | Export-Clixml -Path "$basePath\GPOs.xml"
}

# Export AD configuration
Export-ADConfiguration

# Confirmation message
Write-Host "Active Directory data exported to $basePath"