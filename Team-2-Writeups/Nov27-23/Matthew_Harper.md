# Nov 27 2023 Writeup <!-- omit from toc -->
This is a writeup for the aforementioned date above it is organized into the following 
- [Progress](#progress)
- [Observations](#observations)
- [Improvements/Reflection](#improvementsreflection)

## Progress 
Not much, I did absolutely nothing in preparation for the red teaming. I had some fun ideas but then I had to do word for many other things that hold at this time a bit more importance in my future.

I did notice that a machine "Teleport :)" either had sshkeys enabled (When idk), so I ignored it.
Otherwise most other Linux machines did not see much progress passwords were not changed, and the new accounts were not locked. It may be interesting to make SSH have a "good" outcome for anyone in a valid user list (Us, Blackteam ect), and have everyone else get kicked into some other type of environment. Maybe set them into a container; kill their shell? idk. (FORCEEXEC kill -9 $(ps | grep "bash" | cut -D " " -f4 )).

Really I did nothing interesting, I just SSHed into a machine with a password that was on the list or something that was given to me by Justin. 
## Observations
1) Passwords need to be changed
2) LOCAL SCRIPS NOT RELIANT ON ANSIBLE NEED TO BE USED BY PEOPLE 
3) We can more easily understand and run a bash scripts, they are quick to turn out and I think let people understand things more when it comes to Linux, you can use Ansible as a runner for the scripts if you want to more easily and from a central command deploy them.
4) We need to have a Isolate, observe network, and report oddities procedure.
5) IPTables is taking on :) 
6) We should semi-automate some things so we can remove human error, also would be interesting to finish the manual password change script I started; things probably already exist but doing things isolated from passwd and chgpasswd (Whatever the second is) since they could modify the binary to extract the password
7) If the scoreboard tracks the right thing damage may be spread out more.
## Improvements/Reflection
1) Change password
2) Look at the firewall, often and always.
3) Before trying to fix (if time), try to find the root cause of the issue
4) Once you find the root cause fix it.
5) SSH hardening, Kill all active ssh connections -- Kill all users that are logged in!
6) Upload a SSH Key, and disable password authentication for all except the Blackteam (MATCH statement SSH)
7) We need to find a way to counter and track system Services.

### Note 
Will update with more notes when not tired
