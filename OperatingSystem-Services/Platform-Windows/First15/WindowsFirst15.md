# Windows First 15
- [Windows First 15](#windows-first-15)
  - [Part 1: Initial Network and System Analysis](#part-1-initial-network-and-system-analysis)
    - [1. Nmap Scan for Network Reconnaissance](#1-nmap-scan-for-network-reconnaissance)
  - [Part 2: Securing the Compromised Server](#part-2-securing-the-compromised-server)
    - [1. Create/Alter Admin(s) Account](#1-createalter-admins-account)
    - [2. Turn on Windows Defender](#2-turn-on-windows-defender)
  - [Part 3: Secure Remote Access and Configuration](#part-3-secure-remote-access-and-configuration)
    - [1. Generate and Change Machine Keys](#1-generate-and-change-machine-keys)
    - [2. Copy Public Key to Remote Computer:](#2-copy-public-key-to-remote-computer)
    - [3. Test SSH Key Access](#3-test-ssh-key-access)
    - [4. Disable Password Authentication](#4-disable-password-authentication)
  - [Part 4: Removing Programs \& Malware](#part-4-removing-programs--malware)
    - [1. Keylog Prevention and Service Checks](#1-keylog-prevention-and-service-checks)
    - [2. Process Explorer](#2-process-explorer)
    - [3. Change Passwords for Critical Accounts \& Services](#3-change-passwords-for-critical-accounts--services)
    - [4. Disable Unknown Users](#4-disable-unknown-users)
    - [5. Kill Malicious Processes and Sessions](#5-kill-malicious-processes-and-sessions)
  - [Extra](#extra)
    - [1. Run Audit Scripts](#1-run-audit-scripts)
    - [2. Reminder: Look at the task scheduler](#2-reminder-look-at-the-task-scheduler)

## Part 1: Initial Network and System Analysis

### 1. Nmap Scan for Network Reconnaissance

**Identify Active Machines:**
``` sh

    fping -a -g <start_ip> <end_ip> -r 1 -q > live_hosts.txt
``` 
**Perform Nmap Scan:**
```sh
    nmap -sV -O -T4 -p- -iL live_hosts.txt
```
**Document Findings:**

- Add discovered IPs and services to a shared document or whiteboard.
- Inform the team about active IPs and services.

## Part 2: Securing the Compromised Server

### 1. Create/Alter Admin(s) Account

**Create an Admin Account:**
```sh
    net user admin <password> /add
    net localgroup administrators admin /add
```
**Using GUI**
You(blueteam) can also `ctrl+alt+delete` > `change password`, to alter the password of the current account you are on.

### 2. Turn on Windows Defender

**Enable Windows Defender Firewall:**

- Use Windows Search to find "Windows Defender Firewall".
- Turn it on (may be located on the left side of the screen/window).

**Initiate a Scan:**

- Use Windows Security to run a scan.
- Search "Windows Security" using Window's Search bar and turn it on.

## Part 3: Secure Remote Access and Configuration

### 1. Generate and Change Machine Keys

**Generate SSH Keys:**

Run this command on the host machine:
```sh
    # On a Windows machine
    ssh-keygen -t rsa -b 4096 -f C:\Users\YourUsername\.ssh\ssh_key_name
    ssh-keygen -t <encryption_type -b <size> -f <location to save file(optional)>
    
    # On a Linux machine
    ssh-keygen -t rsa -b 4096 -f /home/<username>/.ssh/custom_key_name
    ssh-keygen -t <encryption_type -b <size> -f <location to save file(optional)>
```
- **Windows**: Keys are located in C:\Users\YourUsername\.ssh\ directory.
- **Linux**: Keys are located in /home/yourusername/.ssh/ directory.

### 2. Copy Public Key to Remote Computer:

```sh
    # From a Linux machine
    ssh-copy-id -i ~/.ssh/your_public_key.pub username@windows_machine_ip
```
```sh
    # Manually copying from Linux to Windows(target) machine (to be done on Windows(target) machine)
    mkdir C:\Users\YourUsername\.ssh\
    notepad C:\Users\YourUsername\.ssh\authorized_keys
```
```sh
    # Note: Remember to change permissions on Windows(target) machine:
    icacls "C:\Users\YourUsername\.ssh" /inheritance:r /grant:r <YourUsername>:F /t /c
    icacls "C:\Users\<YourUsername>\.ssh\authorized_keys" /inheritance:r /grant:r <YourUsername>:F /t /c
```
```sh
    # From a Windows machine
    $key = Get-Content C:\Users\YourUsername\.ssh\my_ssh_key.pub
    ssh username@windows_machine_ip "mkdir C:\Users\YourUsername\.ssh\ -Force; 
    echo $key >> C:\Users\YourUsername\.ssh\authorized_keys"
```
### 3. Test SSH Key Access

- Use another terminal to SSH into the server and ensure key-based authentication works.

### 4. Disable Password Authentication
**Edit SSHD Config:**
```sh
    ## Back up files (cmd)
    Copy-Item -Path "C:\Source\Path\file.txt" -Destination "C:\Backup\Path\file.txt" -Force

    ## Modify sshd configuration
    notepad C:\ProgramData\ssh\sshd_config
```
- Set PasswordAuthentication to no.
- Set PermitRootLogin to no.

**Restart SSHD Service:**
```sh
    Restart-Service sshd
```
## Part 4: Removing Programs & Malware

### 1. Keylog Prevention and Service Checks

**Check for Suspicious Scheduled Tasks and Services:**

    # List running & scheduled tasks/services

    # Tasks
    schtasks /query /fo LIST /v

    # Services
    Get-Service | Where-Object { $_.Status -eq 'Running' }

### 2. Process Explorer

- Download Process Explorer.
  - https://learn.microsoft.com/en-us/sysinternals/downloads/process-explorer#download
- Remove malicious/suspicious processes.
- Pay particular attention to svchost processes, which are often linked to malware.

### 3. Change Passwords for Critical Accounts & Services

**Change Passwords:**
```sh
    net user <username> <newpassword>
```
### 4. Disable Unknown Users

**Identify and Disable Suspicious Accounts:**
```sh
    net user
    # disable user account
    net user <username> /active:no
```
### 5. Kill Malicious Processes and Sessions
This is where process explorer comes into play.

**Check Open SSH Sessions and Processes:**
```sh
    query user  # To see logged-in users
    tasklist /v  # To list detailed processes
    taskkill /F /PID <PID>  # To kill a specific process
```


## Extra

### 1. Run Audit Scripts
**Install and Run Lynis:**

    powershell -Command "Invoke-WebRequest -Uri https://cisofy.com/files/lynis-3.0.8.zip -OutFile lynis.zip"
    powershell -Command "Expand-Archive -Path lynis.zip -DestinationPath ."
    cd lynis && powershell -ExecutionPolicy Bypass -File lynis.ps1

### 2. Reminder: Look at the task scheduler