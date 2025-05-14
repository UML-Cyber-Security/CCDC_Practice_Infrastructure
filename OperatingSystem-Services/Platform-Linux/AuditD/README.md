# Auditd
Auditd is a framework available on Linux systems most of the time by default that allows for extensive log generation when certain events occur. This framework is useful as it allows us to create specific *rules* that are matched when certain *actions* are taken and *conditions* met to generate a log. There are a large number of actions that we can create entries in auditd for, the most common we would use are **watch** rules to create logs when an action is made on a specific *file* or *directory*. We can also create rules that are triggered when certain **systemcalls** are made, it should go without saying that this is quite powerful as every process, unless you are executing in kernel space will need to make systemcalls to have any degree of functionality. The act of creating a process, and exiting said process requires systemcalls so some will always be used!

Based on documentation of [Suse Linux]() the audit framework has the following components with their interactions notes with solid and dotted arrows. 

![Audit Framework](Images/SL-1.png)

> [!NOTE]
> Dotted arrows represent channels of control (applications, services, configuration files, etc) - something that can be used to influence the behavior of the audit framework. While the solid arrows represent the flow of data between each component.

## What can be logged
This document will not be a compressive list of what can or should be logged with the Linux Audit framework, but this section will provide some of the options we can set when creating audit log rules to filter what actions and events are logged. Later sections will discuss how these options can be used to log specific actions.


> [!Important]
> We should refer to something like the [RHEL Audit System Reference](https://access.redhat.com/articles/4409591) to see various event feilds that we can examine and add as conditions to audit rules.

* Specific Users: This can be done by matching the `auid` *audit uid* of a user or the `euid` *effective UID* which can be used to identify sudo commands or those that execute as another user. A simple example of this is when you run `sudo whoami` the output of the command is *root*, this is because sudo makes your *effective UID* 0. We can use the `-F` flag followed by an expression with `auid` or `euid` to configure this, for example `-F euid=0 -F auid>=1000` would track all events that occur by a user that invoked something like the *sudo* command.


> [!NOTE]
> Auditd represents unset uids as the value `-1` but it is interpreted as a unsigned value, so to match this we need to use the value `4294967295` as this is what it will be when printed and interpreted as a unsigned value.
>
> The difference between `uid`, `auid`, and `euid` is that the `uid` will be the ID of the user which executed the command (Changes when user switches accounts with something like su), while `auid` is the ID of the user they logged in as, and `euid` is the effective UID the command was executed as.

* Systemcalls: We can track any systemcall made on the system, though there is alot to consider when configuring the audit rules. Not only do we need to consider the systemcall itself, but we also need to consider the **action** to take and *filter* or *matching list* we will examine to locate the systemcall; for the *matching list* we have the options of *task*, *exit*, *user*, *exclude* and *filesystem*. As for the **action** we have the option of *always* which will always create an event, or *never* which never will.

* File Events: We can match when specific actions are taken against a file or directory, most of the time we will do this with the `-w` options to *watch* a file/directory. This is often paired with the `-p` flag to specify the actions taken of the specified object. This can be read(`r`), write(`w`), execute(`x`) or the modification of a file's attributes(`a`). A full rule may look like `-w /etc/ssh/sshd_config -p w,a -k sshd_conf_event`.

> [!NOTE]
> If we put a watch rule on a directory, it will only log file creation or deletion events within that directory, it will not log events in subdirectories. We can modify the rule as follows
> ```
> -a always,exit -F dir=/etc -F perm=rwa -k etc_monitor
> ```
>
> We can also use a systemcall rule to monitor something in a similar manner:
>```
> -a always,exit -F arch=b64 -S open,openat -F auid>=1000 -F dir=/etc -F perm=wa -F key=conf_changes
>```
> * May have to escape (\\) when using <, >, etc in the auditctl command.

Primarily our use case will focus on monitoring the use of specific command or specific files being edited. So the `-w` watch rules are easy and fairly common, we can make use of the systemcall rule to log any commands executed by root.

## Configuring Audit Daemon
We are not so interested in these configurations, as our use case is not long term and logging to the default locations is for the most part fine we will not need to make too many changes but some will be listed so they could be explored later.

It may be the case we want to increase the number of messages that are queued in the backlog for the audit service to process to the log file, this can be done with the `-b #` flag where the number specifies the number of messages to queue. when this is filled we often set it to make a new log entry that the backlog queue has been filled but with the `-f ` flag this can be changed.

We can also make it so the audit configurations cannot be changed without a system restart by setting the `-e 2` flag, though we likely do not want to do this as restarting the systems will lose us a lot of points!

> [!NOTE]
> Further configuration can be listed in `/etc/audit/audit.conf` include *log_file* to specify where logs are written to, and *max_log_file* for hte maximum size. Additional configurations can be found on the man page or [redhat documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/security_hardening/auditing-the-system_security-hardening#configuring-auditd-for-a-secure-environment_auditing-the-system)
## Writing Rules
Auditd will consume resources, generally we will write more specific and granular rules to avoid extreme increases in CPU utilization. If we were to create logs for every exec systemcalls or every file write we would be unable to get anything useful out of it, especially on systems running complex services like Kubernetes.

The main thing to keep in mind is that the audit log rules are parsed sequentially, and the first one to match is applied. This is just like iptables, where the first rule applied will stop the search. This means if we want to add exclusion rules (if we were really concerned with performance) we could add something like `-a never,exclude ...` to block specific types of log entries from being generated and further compared. This is likely not something we will have to deal with in the time frame and systems we are working on.


> [!NOTE]
> From the [auditd for threat detection](https://izyknows.medium.com/linux-auditd-for-threat-detection-d06c8b941505) we have a list of msg types both from [Redhat](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/security_guide/sec-audit_record_types#sec-Audit_Record_Types) and the [source code](https://elixir.bootlin.com/linux/v6.13.4/source/include/uapi/linux/audit.h#L89)


There are a few kinds of rules we will find useful, the most important we will deal with are the *watch* rules. These rules look for specific actions made on a *file* within the system. This can be editing, executing, modifying permissions of the file.

A *watch* rule would look similar to the following rule:
```
auditctl -w /etc/ssh/sshd_config -p warx -k sshd_config
```
* `-w /etc/ssh/sshd_config`: The file we are watching
* `-p warx`: This means we log write, augmentation, read and execute events.
* `-k sshd_config`: Tag this with sshd_config
  * It can be searched with `ausearch -i -k sshd_config`

> [!NOTE]
> The watch rules for a directory **do not** recursively watch any subdirectories contained within, they only log modifications made to files (the creation or deletion of subdirectories) be that executions, writes, reads or deletion events. We can use the following rule to recursively apply these conditions to subdirectories.
>```
> auditctl -a always,exit -F dir=/etc/ssh -F perm=w -F auid>=1000 -F auid!=4294967295 -k ssh_writes
>```
> * `-F dir=/etc/ssh`: Specify the directory (and all contained subdirectories) we would like to filter on.
> * `-F perm=w`: Filter on writes (Can be changed!)
> * `-F auid!=4294967295`: UID must be set
> * `-k`: Tag

A rule for systemcalls may look like the following:
```
auditctl -a always,exit -S unlink -S unlinkat -S rename -S renameat -F auid>=1000 -F auid!=4294967295 -k delete
```
* `-a always,exit`: Always log from the exit filter (successfully done)
* `-S unlink -S unlinkat -S rename -S renameat`: Monitor the systemcalls *unlink*, *unlinkat*, *rename*, *renameat*
* `-F auid>=1000`: UserID must be 1000 or greater
* `-F auid!=4294967295`: User ID must be set (login ID set)
* `-k delete`: Tag with delete
  * It can be searched with `ausearch -i -k delete`

We can also use another style of audit rule for logging the execution of specific files:
```
auditctl -a always,exit -F exe=/bin/id -F arch=b64 -S execve -k execution_bin_id
```
* `-a always,exit`: Always log from the exit filter (successfully done)
* `-F exe=/bin/id`: Filter on events where the executable ran was /bin/id
* `-F arch=b64`: 64 bit systemcalls
* `-S execve`: Execution systemcall
* `-k execution_bin_id`: Tag as execution_bin_id

> [!IMPORTANT]
> Rules set with auditctl are not persistent, you will want to save them to a numbered file in `/etc/audit/rules.d/` such as `XY-rules.rules`, they are applied in order from hi

## Other Tools

> [!NOTE]
> The [fswatch](https://github.com/emcrisostomo/fswatch) tool can be used to monitor the filesystem for any changes whatsoever.
>
> [Tripwire](https://www.redhat.com/en/blog/security-monitoring-tripwire) or [AIDE](https://www.redhat.com/en/blog/linux-security-aide) can be used for file integrity monitoring.