# AccessChk

### Tool for auditing access controls for users and administrators

## Examples

Show which Registry keys a particular account does not have access to, add more users by separating them with a `\`, e.g., `user1\user2`


`C:\Windows\system32>accesschk -kns breeze hklm\software`
- `k` : Argument is a registry Key
- `n` : Show only objects with no access
- `s` : Recursive
```
C:\Windows\system32>accesschk -kns breeze hklm\software

Accesschk v6.12 - Reports effective permissions for securable objects
Copyright (C) 2006-2017 Mark Russinovich
Sysinternals - www.sysinternals.com

   HKLM\software\Microsoft\EAPSIMMethods\18\FastReauthContext
   HKLM\software\Microsoft\EAPSIMMethods\23\FastReauthContext
   HKLM\software\Microsoft\EAPSIMMethods\50\FastReauthContext
   HKLM\software\Microsoft\WcmSvc\wifinetworkmanager\SharedProfiles
   HKLM\software\Microsoft\Windows\CurrentVersion\Bluetooth\Devices
   HKLM\software\Microsoft\Windows\CurrentVersion\OOBE\SystemProtected
   HKLM\software\Microsoft\Windows\CurrentVersion\SecondaryAuthFactor
   HKLM\software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\CIT\System\Active
   HKLM\software\WOW6432Node\Microsoft\EAPSIMMethods\18\FastReauthContext
   HKLM\software\WOW6432Node\Microsoft\EAPSIMMethods\23\FastReauthContext
   HKLM\software\WOW6432Node\Microsoft\EAPSIMMethods\50\FastReauthContext
```


Print all files that have an explicit integrity level
```
C:\Windows\system32>accesschk -k hklm\software

Accesschk v6.12 - Reports effective permissions for securable objects
Copyright (C) 2006-2017 Mark Russinovich
Sysinternals - www.sysinternals.com

HKLM\software\7-Zip
  R  BUILTIN\Users
  RW BUILTIN\Administrators
  RW NT AUTHORITY\SYSTEM
  R  APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES
  R  S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681
HKLM\software\Adobe
  R  BUILTIN\Users
  RW BUILTIN\Administrators
  RW NT AUTHORITY\SYSTEM
  R  APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES
  R  S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681
HKLM\software\AGEIA Technologies
  R  BUILTIN\Users
  RW BUILTIN\Administrators
  RW NT AUTHORITY\SYSTEM
  R  APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES
  R  S-1-15-3-1024-1065365936-1281604716-3511738428-1654721687-432734479-3232135806-4053264122-3456934681
```

Other notable flags:
- `w`: Show only objects that have write access
- `p`: Argument is a process, use `*` to show all.
    - `f` for full process info
    - `t` to show threads

### Resources

https://docs.microsoft.com/en-us/sysinternals/downloads/accesschk

https://www.guidingtech.com/51113/control-integrity-level-windows-10/

https://docs.microsoft.com/en-us/windows/win32/secauthz/mandatory-integrity-control

https://en.wikipedia.org/wiki/Mandatory_Integrity_Control

