# Password Security and Auditing in Windows

## Password Audit Steps (without Powershell 5)

Need to have at least .NET Framework 4.6 installed.

To check current version of .NET Framework using Powershell (compatible with PowerShell 1.0+):
```(get-itemproperty "HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full").Release -ge 393297 ```
If it returns `False`, need to install more recent version of .NET Framework. Available here:<br/>
https://www.microsoft.com/en-us/download/details.aspx?id=48130

Download NTDSAudit utility from https://github.com/Dionach/NtdsAudit/releases. Just need the `NtdsAudit.exe` file.

Open Windows command prompt with admin privileges. Run the following commands:
```
C:\> ntdsutil

ntdsutil: activate instance ntds
ntdsutil: ifm
ifm: create full c:\passwords
ifm: quit
ntdsutil: quit

```
Navigate to `C:\passwords\Active Directory` folder and copy `NtdsAudit.exe` file obtained from above URL.

This command will dump NTLM password hashes and put users into a `.csv` file.
```
ntdsaudit ntds.dit -s "C:\passwords\registry\SYSTEM" -p pwdump.txt -u users.csv
```
Download John the Ripper for Windows:<br/>
https://www.openwall.com/john/k/john-1.9.0-jumbo-1-win64.zip

Copy the contents of the `run` folder to the same directory as `pwdump.txt`.

Can download a dictionary to check against here:<br/>
https://github.com/danielmiessler/SecLists/tree/master/Passwords/Common-Credentials

Useful commands to run password attacks:<br/>
```
.\john --format=nt pwdump.txt --show
.\john --format=nt pwdump.txt --wordlist=wordlist.txt --rules
```

## Password Audit Steps (Powershell 5)

See DSInternals Powershell script.

## References
- [Info on using NtdsAudit to dump hashes](https://securitynuggets.co.uk/ad-password-auditing-part-1)
- [John the Ripper Info](https://www.dionach.com/en-us/blog/active-directory-password-auditing-part-2-cracking-the-hashes/)



