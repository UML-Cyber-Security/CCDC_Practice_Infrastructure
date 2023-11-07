I spent all of my time at this meeting on the linux2 machine. I tried to find the keylogger on the machine during our 20 minute grace period but after not being able to find it I just changed the password for SSH with the mindset that a new password, even if it is keylogged, is better than keeping the old password. Then I looked for ssh keys in the config file to try to mitigate any backdoors that might be there. I removed all public keys in the /etc/ssh directory using “sudo rm *.pub” and  turned rootlogin permission to “no” in ssh config.

I tried to do part 5 and make an admin account “blackteam” with all access with no passwords
After doing adduser the default password was blackteam, I needed to change it  to be no password. When going into the sudoers file to make blackteam passwordless, I found many other unauthroized accounts with passwordless sudo access so I deleted their entries in the file.

Things I tried to do before getting logged out of the machine completely:
Check /root/.viminfo (SOC suggestion)
Check authorized keys (SOC suggestion)
Check the bashrc file (Chris suggestion)

