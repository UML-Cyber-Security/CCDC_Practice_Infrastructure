## Security Overview of Windows Firewall

By default, Windows Firewall blocks all inbound traffic and allows all outbound traffic. Exceptions to these rules can be defined using the inbound and outbound firewall rules. The GUI for viewing these rules quickly be accessed by the command line `wf.msc` (not sure if this management feature is available on Server core. Rules can be also be viewed from Powershell, see section on "Setting up and viewing Firewall rules from Powershell").

To improve security, one of the goals is to try and block all outbound traffic as well, excepting the ports that are used specifically for Active Directory. Another goal is to disable rules that allow inbound traffic on unused services.

The file `securing_firewall.ps1` is a Powershell script which does the following when run:

1. Resets the firewall rules back to the Windows defaults.
2. Blocks all outgoing traffic.
3. Adsd specific Firewall rules only for the ports needed to run an Active Directory.
4. Disables all Inbound Firewall rules that open ports for unused/unnecessary services.

## Ports used by Active Directory (Client to Controller)

These ports are applicable to versions of Windows Server after and including Server 2008.

| Client Port(s) | Server Port | Service |
|----------------|-------------|---------|
| 49152 -65535/UDP | 123/UDP | W32Time |
| 49152 -65535/TCP | 135/TCP |	RPC Endpoint Mapper |
| 49152 -65535/TCP | 464/TCP/UDP |	Kerberos password change |
| 49152 -65535/TCP |	49152-65535/TCP |	RPC for LSA, SAM, Netlogon (*) |
| 49152 -65535/TCP/UDP |	389/TCP/UDP |	LDAP |
| 49152 -65535/TCP | 636/TCP |LDAP SSL | 
| 49152 -65535/TCP | 3268/TCP | LDAP GC |
| 49152 -65535/TCP | 3269/TCP |	LDAP GC SSL |
| 53, 49152 -65535/TCP/UDP | 53/TCP/UDP | DNS | 
| 49152 -65535/TCP | 49152 -65535/TCP |	FRS RPC (*) |
| 49152 -65535/TCP/UDP | 88/TCP/UDP |	Kerberos |
| 49152 -65535/TCP/UDP | 445/TCP | SMB (**) | 
| 49152 -65535/TCP | 49152-65535/TCP | DFSR RPC (*) |

## Setting up and viewing Firewall rules from Powershell

Example of adding a new firewall rule from Powershell to block outbound traffic: <br/>
`New-NetFirewallRule -DisplayName "Block Outbound Port 80" -Direction Outbound -LocalPort 80 -Protocol TCP -Action Block`

`-DisplayName` gives a name to the rule<br/>
`-Direction` can be "inbound" or "outbound"<br/>
`-LocalPort` will be the port number<br/>
`-Action` can be "allow" or "block"<br/>

To reset the firewall default settings:<br/>
`netsh advfirewall reset`

To get a list of all outbound firewall rules that are currently enabled from command line:<br/>

```
Get-NetFirewallRule | where {$_.Direction -eq "Inbound" -and (($_.Profile -contains "Any") -or ($_.Profile -contains "Public")) -and ($_.Enabled -eq "True"}
```

To disable all inbound firewall rules:<br/>
`Show-NetFirewallRule | where {$_.enabled -eq 'true' -AND $_.direction -eq 'inbound'} | Disable-NetFirewallRule`

## Logging

Logging of dropped packets as well as successful connections can be enabled, though it is not enabled by default. Enabling this setting writes information out to the `pfirewall.log` file. Running these `netsh` commands enables the setting:

```
netsh advfirewall set currentprofile logging filename %systemroot%\system32\LogFiles\Firewall\pfirewall.log
netsh advfirewall set currentprofile logging maxfilesize 4096
netsh advfirewall set currentprofile logging droppedconnections enable
netsh advfirewall set currentprofile logging allowedconnections enable
```
This can also be enabled through the GUI interface by going to `wf.msc` and then `Properties > Logging > Customize...`.


## Resources
- [Ports used by AD](https://support.microsoft.com/en-us/help/179442/how-to-configure-a-firewall-for-domains-and-trusts)
- [Setting up firewall rules from Powershell](https://docs.microsoft.com/en-us/powershell/module/netsecurity/new-netfirewallrule?view=win10-ps)
- [Order of evaluation for Firewall rules](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc755191(v=ws.10)?redirectedfrom=MSDN)
