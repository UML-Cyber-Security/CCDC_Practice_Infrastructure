## Installing Sysmon
Begin by installing Sysinternals Suite and adding it to the system path.

To install Sysmon with default settings (process images hashed with sha1 and no network monitoring):<br/>
`sysmon -accepteula  –i`

To install Sysmon with a particular config file:<br/>
`sysmon –accepteula –i [path to config file]`

A widely recommended "starter" config file for Sysmon can be found [here](https://github.com/swiftonsecurity/sysmon-config).

To uninstall sysmon:<br/>
`sysmon -u`

## Editing Configuration after Install

To edit the configuration after installing (with a config file):<br/>
`sysmon –c [path to config file]`

To return to default config settings:<br/>
`sysmon –c --`

To show the current configuration schema:<br/>
`sysmon -s`

## Viewing Sysmon Logs (GUI)
Navigate to `Windows Administrative Tools > Event Viewer`.

Open dropdowns in the left pane in the following order:<br/>
`Applications and Services Logs > Microsoft > Windows > Sysmon`

Click on `Operational`.

This shows all of the applicable logs in the main window.

## Viewing Sysmon Logs (Powershell)
To view all sysmon logs from command line:<br/>
`Get-WinEvent -filterhashtable @{logname="Microsoft-Windows-Sysmon/Operational"}`

To specify a particular event ID, can add it using a semicolon within the curly brackets:<br/>
`Get-WinEvent -filterhashtable @{logname="Microsoft-Windows-Sysmon/Operational"; id=1}`

More information about accessing Sysmon logs from command line can be found [here](http://909research.com/windows-log-hunting-with-powershell/)

## Resources
- [Microsoft documentation (useful for installation instructions)](https://docs.microsoft.com/en-us/sysinternals/downloads/sysmon)
- [Recommended starter config file](https://github.com/swiftonsecurity/sysmon-config)
- [Viewing Sysmon logs with Powershell](http://909research.com/windows-log-hunting-with-powershell/)
- [Useful webcast on Sysmon](https://www.youtube.com/watch?v=M3ptscFkD1w)
