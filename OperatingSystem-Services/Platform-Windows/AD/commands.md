Below are a list of commands that are useful when performing administrative tasks in active directory

`Import-Module ActiveDirectory`


**User Management Commands**
Create a New User
To create a new user in Active Directory:

`New-ADUser -SamAccountName "jdoe" -UserPrincipalName "jdoe@domain.com" -Name "John Doe" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -Path "CN=Users,DC=domain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true`

Modify User Information
To modify a user's properties (e.g., changing the job title):

`Set-ADUser -Identity "jdoe" -Title "Manager"`

Disable a User Account
To disable a user account:

`Disable-ADUser -Identity "jdoe"`

Enable a User Account
To enable a previously disabled user account:

`Enable-ADUser -Identity "jdoe"`

Reset a User’s Password
To reset a user’s password:

`Set-ADAccountPassword -Identity "jdoe" -NewPassword (ConvertTo-SecureString "NewP@ssw0rd" -AsPlainText -Force) -Reset`

Unlock a User Account
To unlock a user account that is locked out:

`Unlock-ADAccount -Identity "jdoe"`

**Group Management Commands**
Create a New Group
To create a new group in Active Directory:

`New-ADGroup -Name "HR_Group" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=domain,DC=com"`

Add a User to a Group
To add a user to a group:

`Add-ADGroupMember -Identity "HR_Group" -Members "jdoe"`

Remove a User from a Group
To remove a user from a group:

`Remove-ADGroupMember -Identity "HR_Group" -Members "jdoe" -Confirm:$false`

Get Group Members
To list all members of a group:

`Get-ADGroupMember -Identity "HR_Group"`

**Computer Management Commands**
Create a New Computer Account
To create a new computer account in Active Directory:

`New-ADComputer -Name "PC-01" -Path "CN=Computers,DC=domain,DC=com"`

Rename a Computer Account
To rename a computer account:

`Rename-ADObject -Identity "CN=PC-01,CN=Computers,DC=domain,DC=com" -NewName "PC-02"`

Move a Computer Account
To move a computer account to a different Organizational Unit (OU):

`Move-ADObject -Identity "CN=PC-01,OU=OldComputers,DC=domain,DC=com" -TargetPath "OU=NewComputers,DC=domain,DC=com"`

**Organizational Units (OU) Management Commands**
Create a New Organizational Unit
To create a new OU:

`New-ADOrganizationalUnit -Name "Sales" -Path "DC=domain,DC=com"`

Move an Object to an Organizational Unit
To move a user or computer to a different OU:

`Move-ADObject -Identity "CN=John Doe,OU=Users,DC=domain,DC=com" -TargetPath "OU=Sales,DC=domain,DC=com"`

**Querying and Reporting Commands**
Get User Information
To get detailed information about a user:

`Get-ADUser -Identity "jdoe" -Properties *`


Search for Users by Attribute
To search for users based on specific attributes:

`Get-ADUser -Filter {Surname -eq "Doe"} -Properties DisplayName, EmailAddress`

Get All Active Directory Users
To list all users in the domain:

`Get-ADUser -Filter * -Properties DisplayName

Get Group Membership for a User
To see what groups a user is a member of:

`Get-ADUser -Identity "jdoe" | Get-ADUserMembership`

Get All Groups in AD
To list all groups in the domain:

`Get-ADGroup -Filter * | Select-Object Name`

Check Group Membership of a User
To check if a user is a member of a specific group:

`Get-ADUser -Identity "jdoe" | Get-ADUserMembership | Where-Object { $_.Name -eq "HR_Group" }`

**Active Directory Domain Services Commands**
Get Domain Controllers
To list all domain controllers in the domain:

`Get-ADDomainController -Filter *`

Get Forest Information
`Get-ADForest`

**Replicating and Synchronizing AD**
Force Replication Between Domain Controllers
To force replication between domain controllers:

`Sync-ADObject -Object "CN=John Doe,OU=Users,DC=domain,DC=com" -SourceDC "DC1.domain.com" -TargetDC "DC2.domain.com"`

**Active Directory Backup and Restore (DSSU)**
Backup AD Database
You can use the ntdsutil tool to perform a backup or restore:

`ntdsutil.exe "activate instance ntds" "ifm" "create full c:\ADBackup"`

To restore the AD database:
`ntdsutil.exe "activate instance ntds" "restore database c:\ADBackup"`
