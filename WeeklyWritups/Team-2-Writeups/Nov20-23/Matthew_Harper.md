# Nov 20 2023 Writeup <!-- omit from toc -->
This is a writeup for the aforementioned date above it is organized into the following 
- [Progress](#progress)
- [Observations](#observations)
- [Improvements/Reflection](#improvementsreflection)

## Progress 
Not much:
1) Added some password changing capabilities to the user script. 
2) Took an exam the previous week and graded 300 - 400 exams on this day... No time for much.
3) Alex set up teleport for us (thanks friendly red team)
## Observations
1) I had no idea if there was any progress on injects, I kind of passed mine onto Gabe eventually to look through the Linux machines for a reverse shell. Could not find anything running on, or reaching out to the specified port. Possibly on Windows or the command I suggested was off.
2) Time keeping was not done I think, should this be a global or local thing?
3) (Again) Kicking off users is hard where some unknown service is adding them
4) (Again) SOC is important, quite hard to do much in terms of remediation when the SOC server and agents are down. Not their fault, but it just makes it more difficult.
5) Deleting ZSh was kind of funny but also surprisingly effective...
6) Emacs is great
7) Having fun is good. Less stress at this stage. 
8) Score checks relied on one system DNS, probably make it more interesting later on.

## Improvements/Reflection
1) I am curt, Not really doing injects or incident responses since they are long, tedious and in my opinion not worth it at times. Can we streamline this in any way.
2) Adding a known good user is something that **needs** to be done. Could probably automate this. That way we know the local configurations are good. We simply need to audit the global profile and bash configurations. 
   1) Probably want to use bash or some other shell that system services use so the red team won't simply delete the shell binary
3) Firewalls are important but shutting off services and changing passwords first is important. (I forgot about teleport for awhile)
4) Kicking off existing sessions is even more important. 
5) Persistance is annoying
6) Everyone should have their own timer be that on Windows, Linux or something else. 
7) SOC needs to be up if we want any kind of chance at success. Logging is important all systems need audit (Linux) or the windows equivalent. The firewall should preform some kind of logging. 
   1) Can we log systemcalls for domain name resolution (Not consistent)
    ```
    Just see weird outbound IPs in and do `dig -x <IP>`
    ```
8) Probably need to be better at engaging the other people in the group. Stop sitting on my hill and poking things. Better to sit on may hills and poke many things. 
9) Need more audit rules so SOC when it works can determine issues. 