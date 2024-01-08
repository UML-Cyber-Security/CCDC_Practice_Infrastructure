# Security items of interest for CentOS

## Profile:
`PCI-DSS v3.2.1 Control Baseline for Red Hat Enterprise Linux 7`

### Passes:
- NTP
    - Backup servers specified
    - Daemon enabled
    - Remote server specified
- Yum
    - gpgcheck enabled for all yum package repositories
    - Red Hat GPG Key installed
    - gpgcheck Enabled in Main yum config
- Logs
    - Log files have correct ownership and permission


### Fails:

- No `SSH` Idle Timeout Interval is set
- `AIDE` not installed or set up
- `logrotate` not set up
- `libreswan` not installed (IPSec)
- Logging
    - Time modifying events not logged
    - Access control function usage not logged
    - File deletion not logged
    - `auditd` not auditing use of priviledged commands. Probably not even set up.
- Accounts
    - empty password logins enabled
    - lockout time for failed passwords not set
    - password reuse not limited
    - deny for failed passwords attempts not set
    - no password policy set
- smartcard login not enabled


## Profile:
`Standard System Security Profile for Red Hat Enterprise Linux 7`

*Not listing overlapping items

### Passes:
- /var/log in a separate partition
- automounter disabled
- rsyslog installed enabled
- nosuid option to `/dev/shm`
- nodev option to `/dev/shm`

### Fails:
- `at` service enabled, gives attackers more to work with. Generally unnecessary service since cronjobs are used.
- Automatic bug reporting tool enabled: potentially gives attackers a lot of information about the system
- Not much logging. (None is set up by default with centOS)
