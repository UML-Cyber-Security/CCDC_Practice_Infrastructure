# Useful Commands DNS <!-- omit from toc -->

Below are commands that are useful when performing administrative tasks in DNS

- [DNS Module Setup](#dns-module-setup)
- [Get DNS Server Information](#get-dns-server-information)
- [Get DNS Zone Information](#get-dns-zone-information)
  - [List Zones](#list-zones)
  - [Get Zone Information](#get-zone-information)
- [Add a New DNS Zone](#add-a-new-dns-zone)
  - [Create Primary Zone](#create-primary-zone)
  - [Create Secondary Zone](#create-secondary-zone)
- [Add DNS Record (A Record)](#add-dns-record-a-record)
- [Get DNS Records](#get-dns-records)
  - [List All Records](#list-all-records)
  - [List Specific Records](#list-specific-records)
- [Remove DNS Record](#remove-dns-record)
- [Modify DNS Record](#modify-dns-record)
- [Clear DNS Server Cache](#clear-dns-server-cache)
- [Query DNS Records](#query-dns-records)
- [Configure DNS Forwarders](#configure-dns-forwarders)
  - [Add Forwarder](#add-forwarder)
  - [Remove Forwarder](#remove-forwarder)
- [Configure DNS Server Conditional Forwarders](#configure-dns-server-conditional-forwarders)
- [Configure DNS Server Recursion Settings](#configure-dns-server-recursion-settings)
- [Test DNS Server Health](#test-dns-server-health)
- [Get DNS Server Event Logs](#get-dns-server-event-logs)
- [Export DNS Zone](#export-dns-zone)
- [Import DNS Zone](#import-dns-zone)
- [Configure DNS Zone Transfers](#configure-dns-zone-transfers)
- [DNS Server Policies](#dns-server-policies)
  - [Making a zonescope](#making-a-zonescope)
  - [Get Zone Scope](#get-zone-scope)
  - [Making a subnet](#making-a-subnet)
  - [Get Zone Scope Subnet](#get-zone-scope-subnet)
  - [Display all policies](#display-all-policies)
- [Display specific policies:](#display-specific-policies)
  - [Removing a policy](#removing-a-policy)
  - [Whitelist and Blacklist Policies](#whitelist-and-blacklist-policies)

## DNS Module Setup
Ensure that the DNS Server module is installed before running the commands. You can install and import the DNS module by running the following:

```sh
Import-Module DnsServer
```

## Get DNS Server Information
To get general information about the DNS server (including version, status, and DNS zones):

```sh
Get-DnsServer
```

## Get DNS Zone Information

### List Zones
To list all DNS zones configured on the DNS server:
```sh
Get-DnsServerZone
```

### Get Zone Information
To get detailed information about a specific zone:

```sh
Get-DnsServerZone -Name "example.com"
```

## Add a New DNS Zone

### Create Primary Zone
To create a new DNS zone (for example, a primary zone):

```sh
Add-DnsServerPrimaryZone -Name "example.com" -ZoneFile "example.com.dns"
```

### Create Secondary Zone
For a secondary zone (to replicate a zone from another DNS server):

```sh
Add-DnsServerSecondaryZone -Name "example.com" -MasterServers "192.168.1.1"
```

## Add DNS Record (A Record)
To add an A record (host record) to a zone:

```sh
Add-DnsServerResourceRecordA -Name "host1" -ZoneName "example.com" -IPv4Address "192.168.1.100"
```

This will add an A record for host1.example.com with the IP address 192.168.1.100.

## Get DNS Records
### List All Records
To list all DNS records within a specific zone:

```sh
Get-DnsServerResourceRecord -ZoneName "example.com"
```

### List Specific Records
To list a specific type of record, such as A records:

```sh
Get-DnsServerResourceRecordA -ZoneName "example.com"
```

## Remove DNS Record
To remove a DNS record (e.g., an A record):

```sh
Remove-DnsServerResourceRecord -ZoneName "example.com" -Name "host1" -RecordType A -Force
```

## Modify DNS Record
To update a DNS record, for example, changing the IP address of an existing A record:

```sh
Set-DnsServerResourceRecordA -ZoneName "example.com" -Name "host1" -IPv4Address "192.168.1.101"
```

## Clear DNS Server Cache
If you need to clear the DNS cache (for example, after making changes to records), you can use:

```sh
Clear-DnsServerCache
```

## Query DNS Records
To query a specific DNS record using Resolve-DnsName (similar to nslookup):

```sh
Resolve-DnsName "host1.example.com"
```

This will return detailed information about the host1.example.com DNS record.

## Configure DNS Forwarders

### Add Forwarder
To configure DNS forwarding to another DNS server:

```sh
Set-DnsServerForwarder -IPAddress "192.168.1.1"
```
This sets the DNS server to forward queries to 192.168.1.1.

### Remove Forwarder
If you need to remove the forwarder (Remove example from above):
```sh
Remove-DnsServerForwarder -IPAddress "192.168.1.1"
```
## Configure DNS Server Conditional Forwarders
If you need to configure conditional forwarders for specific domains:

```sh
Add-DnsServerConditionalForwarderZone -Name "externaldomain.com" -MasterServers "8.8.8.8" -ReplicationScope "Forest"
```

This forwards queries for externaldomain.com to the DNS server at 8.8.8.8.

## Configure DNS Server Recursion Settings
To enable or disable recursion:

```sh
Set-DnsServerRecursionScope -Enable $true
```
## Test DNS Server Health
To test DNS server health:

```sh
Test-DnsServer
```

## Get DNS Server Event Logs
To retrieve event logs related to DNS operations:

```sh
Get-WinEvent -LogName "DNS Server" -MaxEvents 10
```

## Export DNS Zone
To export a DNS zone to a file:

```sh
Export-DnsServerZone -Name "example.com" -FileName "C:\path\to\export\example.com.dns"
```

## Import DNS Zone
To import a DNS zone from a file:

```sh
Import-DnsServerZone -FileName "C:\path\to\import\example.com.dns"
```
## Configure DNS Zone Transfers
To allow or restrict zone transfers:

```sh
Set-DnsServerZoneTransferPolicy -ZoneName "example.com" -AllowZoneTransfers $true
```

## DNS Server Policies
```sh
Get-Command -Module DnsServer 
```

### Making a zonescope
```sh
Add-DnsServerZoneScope -ZoneName "example.com" -Name "Scope1"
```

### Get Zone Scope
```sh
Get-DnsServerZoneScope -ZoneName "example.com"
```

### Making a subnet
```sh
Add-DnsServerZoneScopeSubnet -ZoneName "example.com" -ZoneScope "Scope1" -Subnet "192.168.1.0/24"
```

### Get Zone Scope Subnet
```sh
Get-DnsServerZoneScopeSubnet -ZoneName "example.com" -ZoneScope "Scope1"
```

### Display all policies
```sh
Get-DnsServerQueryResolutionPolicy 
```

## Display specific policies:

```sh
Get-DnsServerQueryResolutionPolicy | Where-Object { $_.Name -eq "DenyInternalToExternal" } 
```

### Removing a policy
```sh
Remove-DnsServerQueryResolutionPolicy -Name "PolicyName" 
```
### Whitelist and Blacklist Policies
```sh
Add-DnsServerQueryResolutionPolicy -Name "AllowDevZodu"  -Action ALLOW  -ClientSubnet "eq,InternalSubnet" -ZoneScope "InternalScope,2"  -ZoneName "zodu.com" 
```

```sh
Add-DnsServerQueryResolutionPolicy -Name "AllowProxyZodu"  -Action ALLOW -ClientSubnet "eq,ProxySubnet" -ZoneScope "ProxyScope,1" -ZoneName "zodu.com" 
```
 
```sh
Add-DnsServerQueryResolutionPolicy  -Name "DenyDevToPub" -Action DENY  -ClientSubnet "eq,InternalSubnet"  -ZoneName "zodu.com" 
```