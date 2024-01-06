# Made by Justin Marwad 2022

# Make sure that port 1514 is unblocked

# Install ex:       ./Install-Wazuh.ps1 -server [wazuh_ip] -name [name_wazuh_sees] -install  
# Update cert ex:   ./Install-Wazuh.ps1 -server [wazuh_ip] -name [name_wazuh_sees]  
# Restart ex:       ./Install-Wazuh.ps1 -restart
# Uninstall ex:     ./Install-Wazuh.ps1 uninstall

param (
    [string]$server = $null,
    [string]$name = [System.Net.Dns]::GetHostName(),
    [switch]$install = $false, 
    [switch]$uninstall = $false, 
    [switch]$restart = $false
)

If ($install) { 
    Write-Output "[Installing]"

    # Wazuh Install Command 
    Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.2.5-1.msi -OutFile wazuh-agent.msi

    Start-Process -Wait -FilePath "./wazuh-agent.msi" -ArgumentList "/q WAZUH_MANAGER=$server WAZUH_REGISTRATION_SERVER=$server WAZUH_AGENT_NAME=$name"

    # Copy public key to the installation folder
    cp root-ca.pem "C:\Program Files (x86)\ossec-agent"
} 


If ($server) {
    Write-Output "[Installing Certificate]"
    
    # Certify Wazuh with the key 
    & "C:\Program` Files` (x86)\ossec-agent\agent-auth.exe" -m $server -v  "C:\Program` Files` (x86)\ossec-agent\root-ca.pem" -A $name

    # Restart Wazuh for changes to take affect 
    Write-Output "[Restarting]"
    Restart-Service -Name wazuh
}


# Small utilites 
If ($uninstall) {Write-Output "[Uninstalling]"; msiexec.exe /x wazuh-agent.msi /qn}
If ($restart) {Write-Output "[Restarting]"; Restart-Service -Name wazuh}


