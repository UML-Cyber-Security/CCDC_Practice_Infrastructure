Windows 2008 R2 (Windows XP) must use the GUI method since it does not support powershell method, even with Powershell 5.1. A consequence of this, is that scripts using the shared drive must use the fully qualified path \\\\COMPUTER\\SHARE and not typical mapping, unless set in powershell.

# GUI

Create a Shared Folder:

`On chosen folder Right-Click -> Properties -> Sharing -> Share -> Manage permissions -> Share`

Connect to a Shared Folder:

`Right-Click "Computer" in File Explorer -> Map network drive.. -> Type in the Folder value, and change Drive if desired -> Finish`

# Powershell

Get Shares on Computer:

`Get-SmbShare`

Create a Shared Folder:

`New-SmbShare -Name <Share Name> -Path <Path to directory> -EncryptData $True -ReadAccess <Users> -ChangeAccess <Users> -FullAccess <Users> -NoAccess <Users>`

Connect to a Shared Folder: Required for Powershell to see remote path

`New-SmbMapping -LocalPath '<Drive Letter>:' -RemotePath <Path>`
