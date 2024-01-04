# Write-up: Blue Team (Linux)

## Overview
Name: `Leonard Nguyen`

### What We Worked On:
- nmap scanned linux1, linux2, and DNS/Proxy. Found outdated Samba ports in all of them.
    I wasn't very confident that what I found was actually pretty dangerous, even with the 10 or so vulnerabilities Samba 4.6.2 apparently had.
- Looked into some users that seemed suspicious, found alice, bob, eve, and a blank space user. The blank space user had over 20,000 directories that said "justinisgreat"
- Rebuilt the linux2 machine from scratch as the old one was too far gone to be used (Kernel Panic)
- My actual inject task was to create the ansible users for the blackteam to deliver tasks to the machines for whoever is responsible for them to deal with.

### Challenges Faced:
- Prioritizing tasks was a big issue on my part as I wasn't really familiar with the stakes each task took. Actually disabling the port and then finding the services that were creating the alice, bob, eve users should've been first on the list considering how it affected our score in the end. 
- That particular meeting was the first meeting where I had to deal with 2 other machines and actually having to remediate the attacks being done on our machines.
- I probably could've sent some more information regarding the blank space users, the critical vulnerabilities I saw on a website outlining smbd's old version problems.

### Future Plans:
- I'll create the blackteam users and generate the public and private keys for them to be sent to the coaches at some point during the week.
- Secure Docker (Probably with sudo or some fancy file management technology)
- Looking further into what everyone else on my team is doing so I know what to remove and what not to from my machine, to avoid distrupting anyone else's work.
