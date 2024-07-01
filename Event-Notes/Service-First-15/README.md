# Service-First-15
These documents should contain a checklist of **steps** in a relative order of what you will be doing to setup and secure you service, machine or administrative component of the infrastructure in the **FIRST** 15 minuets of the competition.

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
