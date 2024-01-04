Viktor Akhonen
Blue Team Week

Overall Experience: Experience was the best one the SOC team has had so far. Incident responses were actually written this time. 

Pre Meet:
 - Setting up Wazuh and connecting all the agents
 - Setting up important FIM rules on the linux systems
 - Setting up an auto agent restart on all linux machines, so the agent will never disconnect
 - A simple dashboard was created to monitor the systems
 - Windows machines were connected with a basic FIM setup


Issues/Complications: 
 - The Wazuh dashboard password change script apparently did not work as intended
 - On our Wazuh machine, the user creation process could not be found 
	 - Essentially the Red Team had persistent root access the whole time
 - In the very end, docker was compromised and shut down, and a ip table misconfiguration made it impossible to docker compose up
 - Not perfect communication between Wazuh and the team


To-Do: 
 - Add extra information to the dashboard to monitor more logs
 - Add more detailed FIM rules for the Windows machines
	- Maybe look into adding an auto restart script for the windows machines
 - Add to the linux FIM rules 
 - Look into basic IP table
	- Specifically on how to maybe reset the file?
 - Look through Justin's scripts and process that were creating the user accounts
	- Figure out how to prevent this in the future


 
