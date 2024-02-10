# Access

There are three built-in ways the attacker can access the machine.
1. Win-rm
2. SSH
3. RDP

Two important notes before we get started:
1. Disabling an account does not kick it off of active sessions
2. Windows has accounts in many places. For example: local accounts, AD users object, other AD objects, and even hidden system accounts such as krbtgt (I was not able to figure out how to create other system accounts). Also if you want to look into `suborner` attacks to create accounts.

## Win-RM
Win-rm is a remote management session. It is used for scripting tools like ansible. I suggest disabling it with:
```powershell
Stop-Service -Name WinRM
Set-Service -Name WinRM -StartupType Disabled
```

<how to kick off winRM sessions?>

## SSH
SSH can be installed via the server manager. I suggest uninstalling this as well.

You can kick off all ssh sessions with this command:
```powershell
   $sshSessions = Get-Process | Where-Object { $_.Name -eq 'sshd' -or $_.Name -eq 'ssh' }

    # Terminate each SSH session
    foreach ($session in $sshSessions) {
        Stop-Process -Id $session.Id -Force
        Write-Output "SSH session terminated: $($session.Id)"
    }
```

## RDP

## Other
In the past, the red team has installed an OpenSSH Server not through server manager.

