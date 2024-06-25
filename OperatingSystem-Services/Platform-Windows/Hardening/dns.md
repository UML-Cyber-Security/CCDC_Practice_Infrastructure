# DNS
I think it is really funny to mess with the DNS. For example, when their script goes to download a particular file, it is really downloading your malware instead.

I suggest resetting your DNS to the default and erasing any entries that were there before.

```powershell
# Set DNS to default, log to a file
# Define the path to the current user's Documents directory
$DocumentsPath = [System.Environment]::GetFolderPath("MyDocuments")

# Define the path to the hosts file
$HostsFilePath = "C:\Windows\System32\drivers\etc\hosts"

# Define the path for the backup copy
$BackupPath = Join-Path -Path $DocumentsPath -ChildPath "hosts_backup.txt"

# Copy the hosts file to the user's Documents directory
Copy-Item -Path $HostsFilePath -Destination $BackupPath -Force

# Reset the hosts file to default
$defaultHostsContent = @"
127.0.0.1       localhost
::1             localhost
"@

# Overwrite the hosts file with the default content
Set-Content -Path $HostsFilePath -Value $defaultHostsContent -Force
```