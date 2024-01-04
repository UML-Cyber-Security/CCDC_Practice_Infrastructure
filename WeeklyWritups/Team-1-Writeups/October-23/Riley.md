Riley Conners 
10/23 CCDC Report

Red Team:

Homework:  
I worked on a powershell script that created a custom file to accept authorized SSH public keys
 that was separate from the default file and hidden. The public keys would be given as arguments
  and placed in this file by the script.

Monday Night:
I was not able to make any progress in the initial 10 minutes, I think this was just because of
 the initial chaos of it. I wasn’t quite sure what to do and my first few SSH attempts timed out
  and getting into github to access the team scripts took some time.

After planning for 20 minutes there was less stress about what was going on so I tried a few more
 SSH attempts on Linux systems and got into Rocky 2 early on because the shared password file was 
 being updated. 

I was originally able to SSH into another machine from Rocky 2 (I think it was a windows one) but
 I was quickly booted off. I'm not sure if this was a blue team action or if it was the VPN access,
  which was being spotty at the time.

I made a lot of mistakes in doing this, but after a fair amount of time I edited the SSH config
 file in Rocky 2 to include a red team public key in the authorized_keys file for access without a 
 password, and added a secondary hidden authorized_keys file with the public key just in case it was 
 removed from the default file.

After trying to SSH into other machines from Rocky 2 and failing, I decided to try and run an 
infinite loop python script to take up CPU processing. After a few minutes of it not going away we 
took it down because it hurt us as well because we couldn’t try anything else on the machine as it 
was taking a majority of the CPU.

Finally before the end of the session Amaan had used nmap on the router and found open ports that 
I tried to SSH into and Matt H tried to access in the browser. I had no luck using SSH on the ports 
but Matt got into the login screens of multiple interfaces.




