# Injects-Incidents-Infrastructure <!-- omit-from-toc -->
This directory contains materials relating to possible injects, incidents and the infrastructure (it's setup) that we are using. Of note should be the section [Writing Guide](#writing-guide) since this is the main reason this README was made. 

## Table of Contents


## Writing Guide
*Initially Written by Matt Harper...*

This document will give a basic structure that should be used for each of the respective assignments *Service-First-15*, *Service-Possible-Incidents*, and *Service-Possible-Injects*.

This may change as requested by the actual coaches. However so we have some **common** structure I made this.

### All 
All documents should be in a folder with the name of your service **SERVICE**, this folder should contain a file named **README.md**. If you have multiple **sub-services** you can create sub-folders for each **sub-services** inside of the **SERVICE** folder with a README in each.

The **README.md** file will contain your writeups.

If your writeup requires *Images* you should create a folder named **Images** in the **SERVICE** Folder where each image for the writeup will be contained.


See this example below:

<img src="./Images/Example-Structure.png" width=600>

### Service-First-15
This document should contain a checklist of **steps** in a relative order of what you will be doing to setup and secure you service, machine or administrative component of the infrastructure in the **FIRST** 15 minuets of the competition.

This document should be organized in the following manner 

```md
# Service Name
What is this service, what should it be capable of and how secure should it be after this 15 minuets has passed.

## Dependencies
Does your service rely on any other services or machines, is there anything you can do if those are not configured or set up?

## First 15
This should be a Bullet point list of what you do in the first 15, if there is a link to a guide, or small command to run you can include it, Example (Linux):

* SSH Access 
    * Find all SSH authorized keys, log info on them
        ```find -type d -name authorized_keys -exec ls {} \;```
    * Remove pre-existing SSH key
* Audit users
    * Take note of all Unauthorized Users and Keys for report
    * Lock Root Account
        ```passwd -l root```
    * Lock unauthorized Users 
    * Randomize Passwords 
    * Install SSH Keys 
* Secure SSH
    * Config ...

## First 30 
This section should contain anything that should be completed in the first 30 minuets, excluding those mentioned in the first 15 minuets section. Again with the same format 

## Stretch Goals
This is optional, but I would assume appreciated. This section would contain anything you think would be good to have done, but is not something that has to be done in the first 15-30 minuets of the competition.

For example:
* If possible we should configure Multi Factor Authentication for use of Sudo on the Linux Machines. This would help prevent the threat actor from using sudo on accounts who's passwords have been compromised. However due to the chance of lock-out, and the other vectors of attack this may not be worth our time in the first 15-20.
    * We would also have to omit the BlackTeam account from being locked out 
```


### Service-Possible-Incidents
This document should contain possible incidents that can happen to your service. This includes how attackers can use your service to gain access to the infrastructure, or how attackers can misconfigure or take down your service. 

This should have the following format

```md
# Service Name
What is this service, how important to the infrastructure this is (A web-server is not as critical as Wazuh, or Active Directory)

## Possible Misconfigurations 
This section contains information on how your service could be *initially* misconfigured to prevent you from fully utilizing it, or allowing it to work fully.

## Impact
For each possible compromise, how does that impact the infrastructure, does this bring down a critical service. What does it mean when an attacker has compromised this service? Do they have passwords, access to other systems?

## Indicators of Compromise
How can you tell this service was compromised, does it write logs anywhere. Can you create logs when users modify configuration files or run commands?
```

### Service-Possible-Injects
In a slightly differnt structure from the previous assignment each **SERVICE** or **sub-service** folder should contain one or more files, likely titled *inject1.md*, *inject2.md*, etc.

Each of these readme's should contain information relating to a possible inject 

```md
# Service
What is this service, the level of difficulty of this inject.

**Time**: XX (Contains the estimated time of competition)

## Expectations 
What should be implemented and completed by the time this inject is completed 
1. We should have a list of all users on all machines 
2. All unauthorized users should be logged, and locked
3. The password requirements on all Linux machines must bet set to a modern general standard (12 chars, uppercase and lowercase, etc)
4. ...

## Dependencies
What could be attacked while this inject is being implemented to throw those completing it off balance. If a person is auditing users, what happens if more users are added!

## Inject
This is where creative writing skills come into play I guess. Imagine how they could ask you to do this. Then make it more obscure.
```