# Useful Active Directory Commands <!-- omit from toc -->

- [Setup](#setup)
- [User Management Commands](#user-management-commands)
  - [Create a New User](#create-a-new-user)
  - [Modify User Information](#modify-user-information)
  - [Disable a User Account](#disable-a-user-account)
  - [Enable a User Account](#enable-a-user-account)
  - [Reset a User’s Password](#reset-a-users-password)
  - [Unlock a User Account](#unlock-a-user-account)
- [Group Management Commands](#group-management-commands)
  - [Create a New Group](#create-a-new-group)
  - [Add a User to a Group](#add-a-user-to-a-group)
  - [Remove a User from a Group](#remove-a-user-from-a-group)
  - [Get Group Members](#get-group-members)
- [Computer Management Commands](#computer-management-commands)
  - [Create a New Computer Account](#create-a-new-computer-account)
  - [Rename a Computer Account](#rename-a-computer-account)
  - [Move a Computer Account](#move-a-computer-account)
- [Organizational Units (OU) Management Commands](#organizational-units-ou-management-commands)
  - [Create a New Organizational Unit](#create-a-new-organizational-unit)
  - [Move an Object to an Organizational Unit](#move-an-object-to-an-organizational-unit)
- [Querying and Reporting Commands](#querying-and-reporting-commands)
  - [Get User Information](#get-user-information)
  - [Search for Users by Attribute](#search-for-users-by-attribute)
  - [Get All Active Directory Users](#get-all-active-directory-users)
  - [Get Group Membership for a User](#get-group-membership-for-a-user)
  - [Get All Groups in AD](#get-all-groups-in-ad)
  - [Check Group Membership of a User](#check-group-membership-of-a-user)
- [Active Directory Domain Services Commands](#active-directory-domain-services-commands)
  - [Get Domain Controllers](#get-domain-controllers)
  - [Get Forest Information](#get-forest-information)
- [Replicating and Synchronizing AD](#replicating-and-synchronizing-ad)
- [Active Directory Backup and Restore (DSSU)](#active-directory-backup-and-restore-dssu)
  - [Backup AD Database](#backup-ad-database)
  - [Restore AD Database](#restore-ad-database)


## Setup
Below are a list of commands that are useful when performing administrative tasks in active directory

```sh
Import-Module ActiveDirectory
```

## User Management Commands
### Create a New User
To create a new user in Active Directory:

```sh
New-ADUser -SamAccountName "jdoe" -UserPrincipalName "jdoe@domain.com" -Name "John Doe" -GivenName "John" -Surname "Doe" -DisplayName "John Doe" -Path "CN=Users,DC=domain,DC=com" -AccountPassword (ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force) -Enabled $true
```
### Modify User Information
To modify a user's properties (e.g., changing the job title):

```sh
Set-ADUser -Identity "jdoe" -Title "Manager"`
```
### Disable a User Account
To disable a user account:

```sh
`Disable-ADUser -Identity "jdoe"`
```

### Enable a User Account
To enable a previously disabled user account:

```sh
Enable-ADUser -Identity "jdoe"
```

### Reset a User’s Password
To reset a user’s password:

```sh
Set-ADAccountPassword -Identity "jdoe" -NewPassword (ConvertTo-SecureString "NewP@ssw0rd" -AsPlainText -Force) -Reset
```

### Unlock a User Account
To unlock a user account that is locked out:

```sh
Unlock-ADAccount -Identity "jdoe"
```

## Group Management Commands
### Create a New Group
To create a new group in Active Directory:

```sh
`New-ADGroup -Name "HR_Group" -GroupCategory Security -GroupScope Global -Path "CN=Users,DC=domain,DC=com"`
```

### Add a User to a Group
To add a user to a group:

```sh
Add-ADGroupMember -Identity "HR_Group" -Members "jdoe"
```

### Remove a User from a Group
To remove a user from a group:

```sh
Remove-ADGroupMember -Identity "HR_Group" -Members "jdoe" -Confirm:$false
```

### Get Group Members
To list all members of a group:

```sh
Get-ADGroupMember -Identity "HR_Group"
```

## Computer Management Commands
### Create a New Computer Account
To create a new computer account in Active Directory:

```sh
New-ADComputer -Name "PC-01" -Path "CN=Computers,DC=domain,DC=com"
```
### Rename a Computer Account
To rename a computer account:

```sh
Rename-ADObject -Identity "CN=PC-01,CN=Computers,DC=domain,DC=com" -NewName "PC-02"
```

### Move a Computer Account
To move a computer account to a different Organizational Unit (OU):

```sh
Move-ADObject -Identity "CN=PC-01,OU=OldComputers,DC=domain,DC=com" -TargetPath "OU=NewComputers,DC=domain,DC=com"
```

## Organizational Units (OU) Management Commands
### Create a New Organizational Unit
To create a new OU:

```sh
New-ADOrganizationalUnit -Name "Sales" -Path "DC=domain,DC=com"
```

### Move an Object to an Organizational Unit
To move a user or computer to a different OU:

```sh
Move-ADObject -Identity "CN=John Doe,OU=Users,DC=domain,DC=com" -TargetPath "OU=Sales,DC=domain,DC=com"
```

## Querying and Reporting Commands
### Get User Information
To get detailed information about a user:

```sh
Get-ADUser -Identity "jdoe" -Properties *
```

### Search for Users by Attribute
To search for users based on specific attributes:

```sh
Get-ADUser -Filter {Surname -eq "Doe"} -Properties DisplayName, EmailAddress
```

### Get All Active Directory Users
To list all users in the domain:

```sh
Get-ADUser -Filter * -Properties DisplayName
```

### Get Group Membership for a User
To see what groups a user is a member of:

```sh
Get-ADUser -Identity "jdoe" | Get-ADUserMembership
```

### Get All Groups in AD
To list all groups in the domain:

```sh
Get-ADGroup -Filter * | Select-Object Name
```

### Check Group Membership of a User
To check if a user is a member of a specific group:

```sh
Get-ADUser -Identity "jdoe" | Get-ADUserMembership | Where-Object { $_.Name -eq "HR_Group" }
```

## Active Directory Domain Services Commands
### Get Domain Controllers
To list all domain controllers in the domain:

```sh
Get-ADDomainController -Filter *
```

### Get Forest Information
```sh
Get-ADForest
```

## Replicating and Synchronizing AD
Force Replication Between Domain Controllers
To force replication between domain controllers:

```sh
Sync-ADObject -Object "CN=John Doe,OU=Users,DC=domain,DC=com" -SourceDC "DC1.domain.com" -TargetDC "DC2.domain.com"
```

## Active Directory Backup and Restore (DSSU)
### Backup AD Database
You can use the ntdsutil tool to perform a backup or restore:

```sh
ntdsutil.exe "activate instance ntds" "ifm" "create full c:\ADBackup"
```

### Restore AD Database
To restore the AD database:
```sh
ntdsutil.exe "activate instance ntds" "restore database c:\ADBackup"
```
