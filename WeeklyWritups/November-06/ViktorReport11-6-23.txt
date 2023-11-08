Viktor Akhonen
Blue Team Week

Overall Experience: Experience was okay, but again, could have gone better. Wazuh was much more ready this meeting than last meeting, so actuall wazuh tasks were able to be completed. 

Pre Meet:
 - Worked on connecting all the agents and troubleshooting their connections (looking into the ossec.conf files for agents and manager)
 - Looked into setting up FIM for most of the agents (not all), and adding important linux directories
 - Figured out how to properly change machine and wazuh dashboard passwords


Issues/Complications: 
 - Wazuh ran into some problems when we tried to update it and restart the docker container
 - Agents began to disconnet, multiple times, even after they were restarted
 - SSH stopped working for a lot of machines which made it really difficult to restart the agents, or work on anything with that machine in general
 - A lot of alerts in Wazuh were popping up, so it was difficult to tell what was "okay" and wasn't


To-Do: 
 - Set up very specific FIM rules, as our previous rules were very general. (Monitor sudoers file, sshd, bashrc...)
 - Add active reponse to the agents to be able to automatically block ssh bruteforces, or block "bad" ip connections
 - Maybe check for new services (win) or crontabs (linux)
 - Research for an easy or automatic way for agent to restart themselves when shut down

 
