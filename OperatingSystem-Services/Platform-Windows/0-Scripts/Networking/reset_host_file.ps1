# check_host_file.ps1
$hostFilePath = "C:\Windows\System32\drivers\etc\hosts"
$defaultContent = @"
# localhost name resolution is handled within DNS itself.
#	127.0.0.1       localhost
#	::1             localhost
"@
Set-Content -Path $hostFilePath -Value $defaultContent
Write-Host "Hosts file reset to default."
