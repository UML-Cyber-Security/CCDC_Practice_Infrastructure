# Linux First 15
We need to focus on basics, any service breaking operations can be ignored.


1. **On Your Machine** generate a SSH key that you will use to access the competition infrastructure.
    ```
    ssh-keygen -t ecdsa -f ./Cyber-Comp-Key
    ```
    * You do not need a password unless you expect this key to be used on the target machine.
2. Backup Services Configuration files like `SSH`, and `PAM`.
    ```
    sudo cp -r /etc/ssh /etc/ssh.bak && sudo cp -r /etc/pam.d /etc/pam.d.bak && sudo cp /etc/pam.conf /etc/pam.conf.bak
    ```
3. Backup Critical user management files such as `shadow`, `passwd` and `group`
    ```
    sudo cp /etc/shadow /etc/shadow.bak && sudo cp /etc/passwd /etc/passwd.bak && sudo cp /etc/group /etc/group.bak
    ```
4. Backup Account Histories.
    ```
    sudo find /home -type f -iname '.*_history' -exec cp {} {}.bak \;
    ```
   * A better use case would be copying to a centralized location and have the files owned by root.
5. Create a new Group name it something consistent between machines, for example if we are being funny we would name it something like `Minecraft-User`.
    ```
    sudo groupadd Minecraft-User
    ```
6. Make the new group a sudoers group
    ```
     %<newGroup> ALL=(ALL) ALL
    ```
    * we can also do `%<newGroup> ALL=(ALL) NOPASSWD: ALL` if we do not want to use passwords since they likely already compromise them.... Not advised.
7. Create an account named `blueteam`.
    ```
    sudo useradd -m -d /home/blueteam -s /bin/bash blueteam
    ```
8. Add the new user to a sudo (or wheel) group and the group we created previously.
    ```
    sudo usermod -aG sudo blueteam && sudo usermod -aG Minecraft-User blueteam
    ```
9. Give the account a password
    ```
    sudo passwd blueteam
    # OR
    echo "blueteam:PASSWD" | sudo chpasswd # Clear out history file, only do this if we think they have modified or shimmed the password requirements
    ```
10. If team consensus is reached, do this again for another account.
11. Make a backup of all SSH Authorized Key Files for users
    ```
    sudo find /home -type f -iname 'authorized_keys*' -exec cp {} {}.bak \;
    ```
12. Clear out SSH authorized keys
    ```
    sudo find /home -type f -iname 'authorized_keys' -exec echo "" > {} \;
    ```
13. Back up and clear out root authorized keys.
14. Add your **Public Key** to the `authorized_key` file for a few of the users including our `blueteam` account.
    ```
    sudo vim ~blueteam/.ssh/authorized_keys
    ```
    * Paste your public key in.
15. Test your SSH key access to the machine
    ```
    ssh -i /Path/to/private/key blueteam@IP
    ```
    * Note: You can do a jumphost like `ssh -i /Path/to/private/key blueteam@IP -J host1user@host1IP targetuser@tartgetip`

16. Lock all `non-blueteam` and `non-blackteam` accounts.
    ```
    sudo passwd -l <USER>
    ```
    * You can also modify a line in the `/etc/shadow` file with an exclamation point. Though you should only do this from a root shell as this can break the password authentication of that user (why would you be locking yourself).
        ```
        blueteam4:!$y$j9T$QPB0r8sLvi.LM7coxvYKU1$CQTOEClgM5M0oyshyIX2RIXGBTdU8q6X5HcfBF0pRP0:19943:0:99999:7:::
        ```
17. Run the [SSH Hardening Script](https://github.com/UML-Cyber-Security/ccdc2024/blob/main/2-Scripts/Linux/Files-Services-Configs/SSH/SSH-Setup.sh) and manually verify the configuration after. Does the `/etc/ssh/sshd` file have additional `AuthorizedKeys` files, individual user tricks or anything else suspicious.

18. Disable Password Authentication once SSH Keys have been added to the target machine.
    ```
    PasswordAuthentication no
    ```
19. Look at all processes on the system, focus on anything running as root or that has `ssh` in it.
    ```
    sudo ps -auxfww
    ```
20. Look at all processes listening on a port. Look at the service names, and anything listening on a non-standard port.
    ```
    ss -tulpns
    ```
21. Look at all processes sending traffic
    ```
    ss -tupns
    ```
22. Look in the `motd` file to see if there are any shell scripts or commands.
    ```
    vim /etc/motd
    ```
23. Look in the cron related folders `/etc/crontab`, `/etc/crontab.d` and `/var/spool/cron/crontabs`.
24. Run [Linpeas](https://github.com/peass-ng/PEASS-ng/tree/master/linPEAS) and observe the output. Take a good look at any s-bit executables.
    ```
    curl -L https://github.com/peass-ng/PEASS-ng/releases/latest/download/linpeas.sh | sh
    ```
25. Take a quick look in the `/lib/systemd/system` directory. List by age `ls -lhrR` and use grep to narrow it down `2024` for year and a second one with `:` for those created more recently.
    ```
    ls -lhrR /lib/systemd/system | grep 2024 | grep :
    ```
26. Put Audit Rules onto the system. Use the [auditd script](https://github.com/UML-Cyber-Security/ccdc2024/blob/main/2-Scripts/Linux/Files-Services-Configs/Logs/Auditd/Auditd-Install.sh)

