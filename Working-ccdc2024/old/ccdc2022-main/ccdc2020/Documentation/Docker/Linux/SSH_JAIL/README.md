# Goal

Implement a very basic SSH jail for a regular Linux user using Docker. This jail may be helpful -

* To restrict users to their home directory and not be able to read other system and user files.
* To restrict users from running privileged commands even when they have `sudo` on the host system.


# Steps

1. Create a new group called `jail` and add all the users that need to be jailed to that group.

2. Add the following rule in the host's `/etc/sshd_config` to run the jail script when above users authenticate. Remember to restart the SSH service.

    ```
    Match Group jail
        ForceCommand <path-to-script>/run_jail.sh
        X11Forwarding no
        AllowTcpForwarding no
    ```

3. Build the Docker image using the following command - `docker build -t jail .`


# Tests

## With Jail

```
sashank@sndp> ssh sashank@localhost
sashank@localhost's password:
~ $ id
uid=1000(sashank) gid=1000(sashank)
~ $ ls -l /
total 56
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 bin
drwxr-xr-x    5 root     root           360 Jan 20 18:35 dev
drwxr-xr-x    1 root     root          4096 Jan 20 18:35 etc
drwxr-xr-x    1 root     root          4096 Jan 20 18:35 home
drwxr-xr-x    1 root     root          4096 Jan 16 21:52 lib
drwxr-xr-x    5 root     root          4096 Jan 16 21:52 media
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 mnt
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 opt
dr-xr-xr-x  441 root     root             0 Jan 20 18:35 proc
drwx------    2 root     root          4096 Jan 16 21:52 root
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 run
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 sbin
drwxr-xr-x    2 root     root          4096 Jan 16 21:52 srv
dr-xr-xr-x   13 root     root             0 Jan 20 18:35 sys
drwxrwxrwt    2 root     root          4096 Jan 16 21:52 tmp
drwxr-xr-x    7 root     root          4096 Jan 16 21:52 usr
drwxr-xr-x    1 root     root          4096 Jan 16 21:52 var
~ $ exit
```

## Without Jail

```
sashank@sndp> ssh sashank@localhost
sashank@localhost's password: 
Welcome to Ubuntu 19.10 (GNU/Linux 5.3.0-26-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

 * Overheard at KubeCon: "microk8s.status just blew my mind".

     https://microk8s.io/docs/commands#microk8s.status

0 updates can be installed immediately.
0 of these updates are security updates.

Last login: Mon Jan 20 13:35:15 2020 from 127.0.0.1
sashank@sndp> id                                                                                     ~
uid=1000(sashank) gid=1000(sashank) groups=1000(sashank),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),118(lpadmin),128(sambashare),129(docker),998(lxd),1001(jail)
sashank@sndp> exit
```
