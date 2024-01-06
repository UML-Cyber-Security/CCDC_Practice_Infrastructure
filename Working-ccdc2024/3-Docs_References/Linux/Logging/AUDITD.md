# Auditd
##### Written by a sad Matthew Harper
We should not have to deal with this all that much but we can see if the rules failed to load by looking at two things.

First we use the CLI to and **auditctl** to see which rules have been loaded
```
auditctl -l
```

Then we should look at the status of the auditd service. This will show us if the daemon is active, and if the process to load the rules failed. The daemon can be active if the rules failed to load as they appear to be started as two separate processes.
```
systemctl status auditd
```

If we write rules to a .rules file we will need to restart the service before they are applied, as the process that loads the rules is ran when the system boots (or the service is restarted). The rules files will generally be written to /etc/audit/rules.d/*.rules. The format of the file is a newline separated list of valid Auditd rules that we wish to be applied. (We can also load the rules with augenrules --load)

```sh
systemctl restart auditd

# or in the case of RHEL

service auditd restart 
```

If we want to add an individual rules we can use **auditcl** again, we can do the following to create and apply a rule without restarting. 
```
auditctl -w <Rest of Rule>

auditctl -a <Rest of Rule>
```

We can search through the audited logs using the following command to look for specific **keys** we have set.
```
ausearch -k KEY_pwd
```

We can apparently use the following command when auditd is installed to generate a report.
```
aureport -n
```

# Rule format
The **-w** specify that we are watching a file or directory 
The rest of the rule can define what is done to that file or directory. THis rule can be set to trigger on reads (r), writes (w), executes (x) and attribute (a) changes. 

We specify specifics with the **-p** flag, but this can be left out to define any access.
```
auditctl -w <Path-To-File> -p rwxa 
```

The **-a** specifies that we are watching for [syscalls](https://man.archlinux.org/man/syscalls.2). This can be used to check if specific CLI utilities have been invoked, or if a program has done some kind of action. We can specify multiple syscalls in a single rule, and when the the logs will be generated.

```
# From RHEL docs 
auditctl -a action,filter -S system_call -F field=value -k key_name
```

Where the actions can be **always** or **never**. This defines if an event should always be created or never be created. 

Filter defines which kernel filter process should be applied to this event. There are a variety which have different pourposes but we will primarilt use the [user and exit filters](https://www.man7.org/linux/man-pages/man7/audit.rules.7.html#:~:text=The%20exit%20filter%20is%20the%20place%20where%20all,any%20event%20originating%20in%20user%20space%20is%20allowed.)


The **-S** felid specifies a syscall, this can be a number or the name associated with the syscall (names are preferred). Multiple can be included in a rule.

**strace \<command\>** we can use the strace command to see the syscalls that a program makes.


The **-F** field specifies an additional option, this can be UIDs GIDs, Effective UID ect. They are represented as **unsigned integers** so the value of **-1** which represents **no assigned uid** can be displayed as **4294967295**

E.X:
```
# All uids above 1000 (likely min need to check /etc/login.defs) that are not unset.
auditctl <rule> -F auid>=1000 -F auid!=unset
```

NOTE:
We can create a rule to audit use of executables by doing the following:
```
auditctl  -a action,filter [ -F arch=cpu -S system_call] -F exe=path_to_executable_file -k key_name
```

# Ref
* https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/security_guide/sec-defining_audit_rules_and_controls
* https://wiki.archlinux.org/title/Audit_framework -- Recommended
* https://www.digitalocean.com/community/tutorials/how-to-use-the-linux-auditing-system-on-centos-7