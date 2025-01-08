# Reset the firewall rules
Get-NetFirewallRule | Remove-NetFirewallRule
Write-Host "All firewall rules have been reset."

# Configure the firewall
# Deny all inbound
Set-NetFirewallProfile -DefaultInboundAction Block

# Allow necessary AD Traffic and other essential services
$allowedInboundTCPPorts = @(88, 135, 389, 445, 636, 3268, 3269, 3389, 139, 464, 593) + (49152..65535)
$allowedInboundUDPPorts = @(53, 88, 123, 137, 138, 464)

foreach ($port in $allowedInboundTCPPorts) {
    if ($port -is [array]) {
        $portRange = "$($port[0])-$($port[-1])"
        New-NetFirewallRule -DisplayName "Allow Inbound TCP Traffic $portRange" -Direction Inbound -Protocol TCP -LocalPort $portRange -Action Allow
    } else {
        New-NetFirewallRule -DisplayName "Allow Inbound TCP Traffic $port" -Direction Inbound -Protocol TCP -LocalPort $port -Action Allow
    }
}

foreach ($port in $allowedInboundUDPPorts) {
    New-NetFirewallRule -DisplayName "Allow Inbound UDP Traffic $port" -Direction Inbound -Protocol UDP -LocalPort $port -Action Allow
}

# Deny all outbound
Set-NetFirewallProfile -DefaultOutboundAction Block

# Allow necessary outbound traffic
$allowedOutboundTCPPorts = @(88, 135, 389, 445, 636, 3268, 3269, 3389, 139, 80, 443, 464, 593) + (49152..65535)
$allowedOutboundUDPPorts = @(53, 88, 123, 137, 138, 464)

foreach ($port in $allowedOutboundTCPPorts) {
    if ($port -is [array]) {
        $portRange = "$($port[0])-$($port[-1])"
        New-NetFirewallRule -DisplayName "Allow Outbound TCP Traffic $portRange" -Direction Outbound -Protocol TCP -RemotePort $portRange -Action Allow
    } else {
        New-NetFirewallRule -DisplayName "Allow Outbound TCP Traffic $port" -Direction Outbound -Protocol TCP -RemotePort $port -Action Allow
    }
}

foreach ($port in $allowedOutboundUDPPorts) {
    New-NetFirewallRule -DisplayName "Allow Outbound UDP Traffic $port" -Direction Outbound -Protocol UDP -RemotePort $port -Action Allow
}

Write-Host "Firewall configured."
