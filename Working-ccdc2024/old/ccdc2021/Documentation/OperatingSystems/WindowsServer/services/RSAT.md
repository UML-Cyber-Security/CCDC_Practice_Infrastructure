## RSAT

### Using RSAT to Manage Server Core Domain Controller
- Log into client machine (the one you want to remotely manage from)
  - Does not need to be a domain member for most operations
- Add feature `AD DS and AD LDS Tools` from `Add Roles and Features` wizard in Server Manager
  - Located under `Remote Server Administration Tools > Role Administration Tools`
- From cmd: `runas /netonly /user:<IP_of_Domain_Controller>\<Administrator_user_in_domain> mmc`
- This will open an `mmc` window
- Can add a snap-in for `Active Directory Users and Computers` and specify the domain name to manage users
- `gpmc` console can also be used as a snap-in, but need to be a domain member for that

### References
- [Running dsa snap-in remotely](https://theitbros.com/installing-active-directory-snap-in-on-windows-10/) 
