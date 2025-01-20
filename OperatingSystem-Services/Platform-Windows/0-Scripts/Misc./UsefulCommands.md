**FireWall**
```sh
# Enable Remote Desktop (RDP) Firewall Rule
Write-Host "Enabling Remote Desktop Firewall rule..."
Enable-NetFirewallRule -DisplayGroup "Remote Desktop"

# Enable File and Printer Sharing Firewall Rules
Write-Host "Enabling File and Printer Sharing Firewall rules..."
Enable-NetFirewallRule -DisplayGroup "File and Printer Sharing"

# Enable ICMP (Ping) - Allowing ICMP Echo Requests for network diagnostics
Write-Host "Enabling ICMP Echo Requests (Ping)..."
Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall Remote Management"

# Enable inbound traffic for Windows Defender if security software is enabled
Write-Host "Enabling Windows Defender inbound rules..."
Enable-NetFirewallRule -DisplayGroup "Windows Defender Firewall"

# If you want to enable specific RDP port (3389) explicitly
Write-Host "Enabling RDP port (3389) manually..."
New-NetFirewallRule -Name "Allow RDP" -DisplayName "Allow RDP" -Enabled True -Protocol TCP -LocalPort 3389 -Action Allow -Direction Inbound

Write-Host "Firewall rules have been successfully enabled. You should now be able to access the machine via RDP and other network services."

# Confirm firewall status
Get-NetFirewallProfile
```

```sh
#Remove FireWall Rule
# Define the display name of the rule to remove
$ruleDisplayName = "Allow Inbound HTTP"

# Remove the rule
Get-NetFirewallRule | Where-Object {$_.DisplayName -eq $ruleDisplayName} | Remove-NetFirewallRule

Write-Host "Firewall rule '$ruleDisplayName' has been removed."
```

```sh
# Remove all rules from the Domain profile
Get-NetFirewallRule -Profile Domain | Remove-NetFirewallRule

Write-Host "All firewall rules for the Domain profile have been removed."
```

****
