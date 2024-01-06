## Instructions on installing Windows updates (Powershell)

The PSWindowsUpdate module can be used to perform windows updates from Powershell. The following script installs PSWindowsUpdate if it does
not already exist on the system and updates the system with all available updates. It can be tweaked to only install certain updates, if
desired.

```
if (-Not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
	Install-Module PSWindowsUpdate -Confirm:$false
	Import-Module PSWindowsUpdate -Confirm:$false
	Add-WUServiceManager -ServiceID 7971f918-a847-4430-9279-4a52d1efe18d -Confirm:$false
}

Get-WUInstall –MicrosoftUpdate –AcceptAll –AutoReboot -Install
```

The previous script will automatically reboot the system. The -AutoReboot flag can be removed if we choose to manually determine if the system
needs to be rebooted after an update. To determine if a system reboot is required:

```
Get-WURebootStatus
```

To just list all of the available updates without installing them:

```
Get-WUInstall –MicrosoftUpdate
```

Full list of available cmdlets in the PSWindowsUpdate module:

```
Get-Command -Module PSWindowsUpdate
```

## Instructions on installing Windows updates (GUI)

- Go to Settings
- Go to ```Updates and Security``` at the bottom of the page 
- Click ```Check for Updates```
- Install the updates
- Reboot if needed to complete install

## Resources
- [Powershell install](http://woshub.com/pswindowsupdate-module/)
- [GUI Install](https://heresjaken.com/install-updates-windows-server-2016/)

