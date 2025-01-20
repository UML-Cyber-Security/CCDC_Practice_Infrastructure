# Define the path to the dump folder in the user's Documents
$folderPath = [System.IO.Path]::Combine([Environment]::GetFolderPath("MyDocuments"), "Dump")
If (!(Test-Path -Path $folderPath)) {
    New-Item -ItemType Directory -Force -Path $folderPath
}

# Function to check if the machine is a Domain Controller
function Is-DomainController {
    $dc = (Get-WmiObject Win32_ComputerSystem).DomainRole
    return $dc -eq 5 -or $dc -eq 6
}

# Dump DNS records if the machine is a Domain Controller
if (Is-DomainController) {
    try {
        # Export DNS zones and records
        $dnsZones = Get-DnsServerZone
        foreach ($zone in $dnsZones) {
            $zoneName = $zone.ZoneName
            $records = Get-DnsServerResourceRecord -ZoneName $zoneName
            $records | Export-Csv -Path "$folderPath\DNS_$zoneName.csv" -NoTypeInformation
        }
        # Combine all CSV files into a single text file
        Get-ChildItem "$folderPath\DNS_*.csv" | Get-Content | Out-File "$folderPath\DNS.txt" -Encoding utf8
        # Clean up individual CSV files
        Get-ChildItem "$folderPath\DNS_*.csv" | Remove-Item
    } catch {
        Write-Error "An error occurred exporting DNS records: $_"
    }
} else {
    Write-Host "This machine is not a Domain Controller."
}