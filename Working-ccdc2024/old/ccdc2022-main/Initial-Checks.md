# Initial Checks 

These are some initial checks that can / should be done to get some basic security tasks out the way and to fix some common vulnerablities.

# Resources
https://www.cyberciti.biz/tips/linux-security.html



## Linux 
1.  Check Bash history for ALL users.

    a. Find the spicy stuff.

    b. Make a backup of the logs.
2. Ensuring FTP isn't installed
3. Ensure Telnet is disabled / uninstalled
4. Check sudo group
5. Check sudoers file
6. Check SSH config files

    a. Disable Root Login
    
    b. Disable password-authentication if keys are in place.
7. Ensure that SELinux is enabled (if applicable) 
8. Lock empty password accounts
9. Make sure no non-root accounts have UID Set to 0
10. Ensure UFW has a deny all incoming (Add the SSH rule first!)
11. Ensure audit.d is up and running. 
12. Disable services that aren't needed
13. Change the default passwords (especially weak ones)




# Windows

1. Change ALL passwords of EVERY user.

    Make note of all the users on the system (Think of it as insurance and taking your own inventory of the users). You can do this with either the "Computer Management" application if you have a GUI interface or you can use the command prompt.


    Computer Management:

        1. Search "Computer Management"

        2. Under the tree structure on the LHS, Expand the "System Tools -> Local Users and Groups -> Users" Tab.

        3. You'll be presented with a list of users for the machine. 

        4. Confirm:

            a. _DefaultAccount_ is disabled. Right-click and choose _Properties_. Check _Account is disabled_

            b. _Guest_ is disabled. Same steps

            3. _WDAGUtility_ is disabled. Same steps.

        5. You can set a password through right clicking it.
        

    Command Prompt:

        1. Open up a command prompt as an administrator.

        2. The format for the command is "net user <<Username>> <<New Password>>"

            a. Example (Basic): 
                net user SomeUserName GreatPassword
            b. Example with a space in the username is:                 
                net user "User Name" GreatPassword
                


