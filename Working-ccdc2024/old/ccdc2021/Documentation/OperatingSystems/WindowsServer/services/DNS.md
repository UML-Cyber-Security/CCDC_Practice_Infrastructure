# DNS

## Objective
Implement the DNS server role on Windows and secure it properly.

**Note:** The DNS role is automatically installed on a Domain Controller when the Active Directory Domain Services role is installed.

## Security Analysis
- Protection from DNS spoofing attacks
    - Use Domain Name System Security Extensions `DNSSEC` to validate DNS responses by signing zones
        - Configure Name Resolution Policy in Group policy settings to require that clients use `DNSSEC` on top of `IPsec`
    - Lock down DNS cache 
    - Configure the size of the DNS socket pool (default recommended is 2500 sockets, max is 10000)
    - Force DNS zones to allow only secure dynamic updates
- Protection from unauthorized zone transfers for recon purposes
    - Block zone transfers
- Monitoring and troubleshooting
    - Set up PTR records and reverse lookup zones for troubleshooting using `nslookup`
    - Enable DNS debug logging
    - Use Microsoft's Best Practice Analyzer tool

### Notes about Early Versions
- Powershell 5 can be used in versions > Windows 10/Windows Server 2016. Otherwise, use `dnscmd` scripts.
- DNSSEC is not fully supported until Windows Server 2012, it has partial support in Windows Server 2008 R2 (intended for static, file-backed DNS zones and not dynamic AD integrated DNS zones since dynamic updates are not supported)

## Installation and Security Script with Comments (dnscmd)
```
# to disable zone transfers
dnscmd SERVER /ZoneResetSecondaries 'ccdc.uml.edu' /NoXfr

# to lock DNS cache. The percent means that the DNS server will not overwrite a cached entry for 
# 70% of the duration of the TTL (default is 100%)
dnscmd /Config /CacheLockingPercent 70

# enable logging
dnscmd.exe localhost /Config /LogLevel 0x6101

# disable logging 
dnscmd.exe localhost /Config /LogLevel 0x0

# to change the size of the DNS socket pool to 2500 (can be up to 10000)
dnscmd /config /socketpoolsize 5000

# to force only allow secure updates
dnscmd SERVER /Config 'ccdc.uml.edu' /AllowUpdate 2
```

## Installation and Security Script with Comments (Powershell 5)
```
# install DNS
Install-WindowsFeature DNS -IncludeManagementTools

# sign a DNS zone using default DNSSEC settings
Invoke-DnsServerZoneSign -ZoneName "test.net" -SignWithDefault -PassThru -Verbose

# to disable zone transfers
Get-DnsServerZoneTransferPolicy -ZoneName "contoso.com" | Remove-DnsServerZoneTransferPolicy -ZoneName "contoso.com" -Force

# to lock DNS cache. The percent means that the DNS server will not overwrite a cached entry for 
# 70% of the duration of the TTL (default is 100%)
Set-DnsServerCache –LockingPercent 70

# to enable logging on DNS
Set-DnsServerDiagnostics -All $True

# to change the size of the DNS socket pool to 2500 (can be up to 10000)
dnscmd /config /socketpoolsize 5000

# to force allow only secure updates
Set-DnsServerPrimaryZone -Name "western.contoso.com" -DynamicUpdate "Secure" -PassThru

# run a Best Practices Scan from PS
Get-BpaResult –ModelId Microsoft/Windows/DNS
```

## Exporting/Importing DNS Settings and Performing a Backup (verified on Windows Server 2008 R2)
To export DNS settings to a `.txt` file using `dnscmd`:
```
dnscmd DNS-SERVER /zoneexport "ccdc.uml.edu" "ccdc_settings.txt"
```
To import DNS settings from a `.txt` file using `dnscmd`:
```
dnscmd DNS-SERVER /zoneadd "ccdc.uml.edu" /primary /file "ccdc_settings.txt"
```
To do a full backup of all DNS zones on a server, run this batch file:<br/>
https://gallery.technet.microsoft.com/scriptcenter/5931a49f-e7d0-4d5d-aff4-cb799213b29f

## Setting up a Split DNS on Active Directory
### GUI
Steps to create a new zone:
- Open DNS Manager `dnsmgmt` from powershell
- Right-click `Forward Lookup Zones` and `New Zone...`
- Accept defaults in the wizard and enter the new parent zone
- Right-click the new zone on the right pane and click `New Host...`
- Leave the name blank and set the IP to the AD Domain controller IP, click `OK`

Steps To create a subdomain(s) under the zone:
- Right-click the new zone and click `New Host...`
- Enter the name of the desired subdomain (not the FQDN)
- Enter the IP address of the computer that you want the subdomain to point to, click `OK`

### PS script
```
# Create a new forward lookup zone (change IP address to DCs IP address)
Add-DnsServerPrimaryZone -Name "ccdc.uml.edu" -ReplicationScope "Domain" -PassThru
Add-DnsServerResourceRecordA -ZoneName "ccdc.uml.edu" -IPv4Address "10.0.0.29"

# To create a new subdomain underneath that zone (change IP to what you want the subdomain to point to)
Add-DnsServerResourceRecordA -Name "vuln" -ZoneName "ccdc.uml.edu" -IPv4Address "10.0.0.23"

```
## References

- [DNSSEC implementation](https://newhelptech.wordpress.com/2017/07/02/step-by-step-implementing-dns-security-in-windows-server-2016/)
- [DNSSEC overview](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj200221%28v%3dws.11%29)
- [Setting up a split DNS](https://www.petenetlive.com/KB/Article/0000830)
- [Best practices for securing DNS on Windwos](https://activedirectorypro.com/dns-best-practices/)
