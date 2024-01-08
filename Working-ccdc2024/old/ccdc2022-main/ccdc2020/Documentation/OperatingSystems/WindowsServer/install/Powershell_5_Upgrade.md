# 2008 R2 (Windows XP)

First, you must either use IE (not recommended) or download another browser (like Firefox).

[Firefox Windows Download (Direct)](https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US)


Next, Windows 2008 R2 requires Service Pack 1 to upgrade to Powershell 5.1. This is likely already installed you can check from

`Control Panel -> System and Security -> System -> Windows Edition`

[Service Pack 1 Download (Direct 2008 R2)](https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-X64.exe)

Next, an updated version of .NET is required, we will use .NET 4.6.1

[.NET 4.6.1 Download (Direct)](https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe)

Finally, Install Windows Management Framework 5.1 (Powershell 5.1)

[WMF 5.1 Download (Direct)](https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip)

Restart Computer and you are all done!

You can check Powershell Version with:

`Get-Host | Select-Object Version`

# 2012 R2 (Windows 7)

If Windows 7 doesn't already have Service Pack 1, must install it.

`wget -Uri 'https://download.microsoft.com/download/0/A/F/0AFB5316-3062-494A-AB78-7FB0D4461357/windows6.1-KB976932-X64.exe' -O SP_1.exe`

`& SP_1.exe`

First, an updated version of .NET is required, we will use .NET 4.6.1

`wget -Uri 'https://download.microsoft.com/download/E/4/1/E4173890-A24A-4936-9FC9-AF930FE3FA40/NDP461-KB3102436-x86-x64-AllOS-ENU.exe' -O NET_4_6_1.exe`

`& NET_4_6_1.exe`

Finally, Install Windows Management Framework 5.1 (Powershell 5.1)
`wget -Uri 'https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win8.1AndW2K12R2-KB3191564-x64.msu' -O WMF5.msu`

`& WMF5.msu`

For Windows 7 use, 

[WMF 5.1 (Windows 7)](https://download.microsoft.com/download/6/F/5/6F5FF66C-6775-42B0-86C4-47D41F2DA187/Win7AndW2K8R2-KB3191566-x64.zip)

You can check Powershell Version with:

`Get-Host | Select-Object Version`

# 2016 (Windows 8)

Pre-installed

# 2019 (Windows 10)

Pre-installed
