Below are commands that are useful when performing administrative tasks in DNS

**DNS Module Setup**
Ensure that the DNS Server module is installed before running the commands. You can install and import the DNS module by running the following:

`Import-Module DnsServer`

**Get DNS Server Information**
To get general information about the DNS server (including version, status, and DNS zones):

`Get-DnsServer`

**Get DNS Zone Information**
To list all DNS zones configured on the DNS server:

`Get-DnsServerZone`

To get detailed information about a specific zone:

`Get-DnsServerZone -Name "example.com"`

**Add a New DNS Zone**
To create a new DNS zone (for example, a primary zone):

`Add-DnsServerPrimaryZone -Name "example.com" -ZoneFile "example.com.dns"`

For a secondary zone (to replicate a zone from another DNS server):

`Add-DnsServerSecondaryZone -Name "example.com" -MasterServers "192.168.1.1"`

**Add DNS Record (A Record)**
To add an A record (host record) to a zone:

`Add-DnsServerResourceRecordA -Name "host1" -ZoneName "example.com" -IPv4Address "192.168.1.100"`

This will add an A record for host1.example.com with the IP address 192.168.1.100.

**Get DNS Records**
To list all DNS records within a specific zone:

`Get-DnsServerResourceRecord -ZoneName "example.com"`

To list a specific type of record, such as A records:

`Get-DnsServerResourceRecordA -ZoneName "example.com"`

**Remove DNS Record**
To remove a DNS record (e.g., an A record):

`Remove-DnsServerResourceRecord -ZoneName "example.com" -Name "host1" -RecordType A -Force`

**Modify DNS Record**
To update a DNS record, for example, changing the IP address of an existing A record:

`Set-DnsServerResourceRecordA -ZoneName "example.com" -Name "host1" -IPv4Address "192.168.1.101"`

**Clear DNS Server Cache**
If you need to clear the DNS cache (for example, after making changes to records), you can use:

`Clear-DnsServerCache`

**Query DNS Records**
To query a specific DNS record using Resolve-DnsName (similar to nslookup):

`Resolve-DnsName "host1.example.com"`

This will return detailed information about the host1.example.com DNS record.

**Configure DNS Forwarders**
To configure DNS forwarding to another DNS server:

`Set-DnsServerForwarder -IPAddress "192.168.1.1"`

This sets the DNS server to forward queries to 192.168.1.1. If you need to remove the forwarder:

`Remove-DnsServerForwarder -IPAddress "192.168.1.1"`

**Configure DNS Server Conditional Forwarders**
If you need to configure conditional forwarders for specific domains:

`Add-DnsServerConditionalForwarderZone -Name "externaldomain.com" -MasterServers "8.8.8.8" -ReplicationScope "Forest"`

This forwards queries for externaldomain.com to the DNS server at 8.8.8.8.

**Configure DNS Server Recursion Settings**
To enable or disable recursion:

`Set-DnsServerRecursionScope -Enable $true`

**Test DNS Server Health**
To test DNS server health:

`Test-DnsServer`

**Get DNS Server Event Logs**
To retrieve event logs related to DNS operations:

`Get-WinEvent -LogName "DNS Server" -MaxEvents 10`

**Export DNS Zone**
To export a DNS zone to a file:

`Export-DnsServerZone -Name "example.com" -FileName "C:\path\to\export\example.com.dns"`

**Import DNS Zone**
To import a DNS zone from a file:

`Import-DnsServerZone -FileName "C:\path\to\import\example.com.dns"`

**Configure DNS Zone Transfers**
To allow or restrict zone transfers:

`Set-DnsServerZoneTransferPolicy -ZoneName "example.com" -AllowZoneTransfers $true`
