# Writeup

## Overview
November 6th Writeup

Name: ```Matthew Hudzikiewicz```

## Leading up to Weekly Meeting
-   Tried to getting FIM (File Integrity Monitoring) set up on all machines
    -  Should have set this up earlier becuase we missed some files being modified on some machines
-   Worked on getting VirusTotal integration set up to detect and remove malware however was not fully functional 


## During Meeting

### Challenges
-   The connection to the wazuh agents were buggy so sometimes they were disconnecting
-   Our file integrity management was not perfect so stuff was leaking through our detecting

-   We forgot to change the Wazuh Dashboard username and password so they had access to it the whole time leading to problems with agents and logs

- SSH was then disabled on some machines which made it difficult to fix the problems when we did find them

### Successes
-   Our FIM was working on some of the agents showing files being modified, deleted, and added but was unorganized so did not get as much value as needed.

-   We were able to monitor some incidents and report them to teams but we were not efficient enough to fix them in time

## Work todo for next blue team session
- Create dashboards to monitor changes to specific file
    - Files to explicitly monitor including:
        - /var/ossec/etc/ossec.conf
        - /.bashrc
        - Communicate with specific teams to know which specific files to monitor
    - Create queires for specific problems that we want to handle ( Creating Priority)
- Figure out the problem with agents disconnected and finding a way to get them back online as quick as possible.

- Get the VirusTotal Integration working properly to detect and automatically delete malware

- Research Better Practices to add to our wazuh system to detect vulnerablities more efficiently so we can provide better detection

#### COMMUNICATION ###
 - Talk with other team members to find what they want us to specifically monitor. 

 - Talk among my SOC team members to divy up the work so we can work efficiently
