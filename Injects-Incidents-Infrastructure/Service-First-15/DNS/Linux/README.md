# Linux DNS
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