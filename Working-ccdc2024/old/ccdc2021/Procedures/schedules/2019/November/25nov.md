# Uriah got hacked

## November 25<sup>th</sup> Training Schedule:

## Deliverables prepared for practice:
- Chris
  - Alpine git service documentation added to `Alpine/services/git/README.md`
- Fabrizio
  - CentOS security review
    - 3 unique security items added to `CentOS/installation/README.md`
    - 1 unique script that secures or audits different security concerns with Bash added to `CentOS/installation/`
  - Alpine security review
    - 3 unique security items added to Alpine/installation/README.md
    - 1 unique script that secures or audits different security concerns with Bash added to `Alpine/installation/`
- Grace
  - Cisco 2811 security review
    - 2 unique security items added to `Cisco2811/README.md`
  - CentOS DHCP server documentation added to `CentOS/services/dhcp/README.md`
- Joel
  - CentOS security review
    - 3 unique security items added to `CentOS/installation/README.md`
    - 1 unique script that secures or audits different security concerns with Bash added to `CentOS/installation/`
  - Alpine security review
    - 3 unique security items added to `Alpine/installation/README.md`
    - 1 unique script that secures or audits different security concerns with Bash added to `Alpine/installation/`
- Liam
  - CentOS vpn service documentation added to `CentOS/services/vpn/README.md`
- Mary
  - Windows 10 security review
    - 3 unique security items added to `Windows10/instllation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `Windows10/installation/`
  - Windows Server 2016 security review items
    - 3 unique security items added to `WindowsServer2016/installation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `WindowsServer2016/installation/`
- Rakshith
  - CentOS mail server using [Postfix for SMTP, Dovecot for POP/IMAP and Dovecot SASL for SMTP AUT](https://www.krizna.com/centos/setup-mail-server-centos-7/) documentation added to `CentOS/services/mailServer/README.md`
- Rose
  - Windows 10 security review
    - 3 unique security items added to `Windows10/instllation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `Windows10/installation/`
  - Windows Server 2016 security review items
    - 3 unique security items added to `WindowsServer2016/installation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `WindowsServer2016/installation/`
- Uriah
  - Cisco 2811 security review
    - 2 unique security items added to `Cisco2811/README.md`
  - CentOS Bind9 server documentation added to `CentOS/services/dns/README.md`
- Vlad
  - Make a commmand line score server that uses your script and then totals points (Python?), added to `Documentation/practice/score/`
- Yassir
  - CentOS SSH server documentation added to `CentOS/services/ssh/README.md`
  - CentOS Apache server documentation added to `CentOS/services/apache/README.md`
- Zach
  - Windows 10 security review
    - 3 unique security items added to `Windows10/instllation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `Windows10/installation/`
  - Windows Server 2016 security review items
    - 3 unique security items added to `WindowsServer2016/installation/README.md`
    - 1 different script that secures or audits different security concerns with Powershell added to `WindowsServer2016/installation/`

## SOPs to keep in mind:
- Task primers received and processed ahead of time
- Double check your work ***before*** pressing `enter`
- Ensure file integrity
- Map workstations and IPs

## 1730-1735, Announcements

- Team Leads
  - Temporary for now, will change each week to give everyone an opportunity
  - Similar to the compeition, consider everything an evaluation
  - Permenant assignment will happen later after winter break
  - "Chain of Command" (Used in industry / high performing civilan teams daily, although popularly attirbuted to the military)
  - Team Members communicate with Team Leads, Team Leads communicate with Co-Captain / Captain
- Vlad to focus on training Red Team
- Secretary?
- Practice look ahead:
  - 2 Dec, 9 Dec as normal
  - 16 Dec off for finals or 23 Dec off for Christmas break (people traveling?)
    - Want to avoid losing both to dodge memory rot, maybe pick a new day?
- Reporting during practice
  - [Incident Report Example](https://sites.google.com/site/howtoccdc/scoring/incident-report)
  - [Inject Report Example](https://sites.google.com/site/howtoccdc/scoring/injects)

## 1735-1750: Quick Group Security Briefs

Each identified person will have no more than 5 minutes to discuss what their group developed-- they will need to speak for their entire sub team. Listeners should save strategic questions / comments for focus sessions-- clarifying questions are good.

#### A: Quick brief of Secruity Items
- ALL ATTEND (To include Red Team, Sashank, and potential new members)
- 5 min: Mary, Windows items
- 5 min: Grace, Cisco items
- 5 min: Joel, Linux items

## 1750-1815: Focused Security Review

Discuss strategic changes due to review items, discuss changes in how the sub team should operate, consider any extra "holes" in our OS / networking security. Ensure to encapture all worthwhile ideas in the ToDo list for later consideration during our second security review.

#### A: 15min, Linux Security review with CentOS and Alpine
- Joel
- Fabrizio
- Rakshith
- Chris
- Liam

#### B: 15min, Windows Security review with Windows Server 2019 and Windows 10
- Mary
- Rose
- Zach

#### C: 15min, Networking with Cisco equipment
- Grace
- Uriah

#### D: 15min, Group Scenario Setup
- Vlad
- Bradford
- Noah?
- Shrutika?
- Sashank

## 6:15pm - 6:30pm, Group Scenario inbrief

## 6:30pm - 7:30pm, Group Scenario

**Setup**:

Publish tested IPs / ports for the ssh, active directory, and mail services before scenario starts

**Scenario**:

The IT team needs to put up a secure SSH, Apache, mail, and MySQL server, along with Windows Active directory.

## Roles:

- **Vlad** (Black/Red Team)
  - Create the "string" being checked for on apache
  - Create the public key for the ssh check
  - Create a small MySQL table to query
  - Begin checking for ssh, apache (linux), MySQL (windows), active directory, and mail services (linux)
  - ???
  - Profit
  - Attack and cause **d̮̻̲͉̘ͮͧ̽͐ͤam̱̺̗͕̠̱̄̂̂͛ͬ̑a̪̹̹̐̉͊g̠̘͓e̴͖̩͍̔̈́͌**
  - Do a flip
- **Liam** (Infrastructure)
  - Set up a git server on Alpine Linux
  - Username/Password authentication
  - Verify repo is accessible
  - Type in CentOS, Windows Server 2016, and Windows 10 security scripts
  - Hash each with SHA-1 and share the first 5 characters to relevant team members
  - Announce when a new script is available
- **Unassigned** (Infrastructure)
  - Develop inject reports for each inject as they come in
  - Develop incidence response reports if damage happens
- **Unassigned** (Linux):
  - Install CentOS
  - Pull CentOS secuirty scripts as available
    - Verify
    - Run
  - Pull the apache installation script
    - Verify
    - Run
  - Retrieve a unique string to place in a website from Black Team
  - Ensure that apache is being "checked" by Black Team
  - Monitor logs and immediately report attacks against the system to the Co-Captain
- **Chris** (Linux):
  - Install CentOS
  - Pull CentOS secuirty scripts as available
    - Verify
    - Run
  - Pull the ssh installation script
    - Verify
    - Run
  - Retrieve a public ssh key from Vlad
  - Ensure that ssh is being "checked" by Vlad
  - Monitor logs and immediately report attacks against the system to the Co-Captain
- **Joel** (Temporary Team Lead / Linux):
  - Install CentOS
  - Pull CentOS secuirty scripts as available
    - Verify
    - Run
  - Pull the mail installation script
    - Verify
    - Run
  - Ensure that mail is being "checked" by Black Team
  - Report compleition of Linux Team items to Captain
  - Monitor logs and immediately report attacks against the system to the Co-Captain
- **Grace** (Networking):
  - Set up the router to connect the Internet (lab networking equipment), public services, and the DMZ
    - The DMZ will contain the git server
    - Public services include mail, Apache, and SSH
    - The internet is just connection back into the lab back bone
- **Rose** (Windows)
  - Install Windows Server 2016
  - Pull Windows Server 2016 secuirty scripts as available
    - Verify
    - Run
  - Pull the MySQL installation script
    - Verify
    - Run
  - Create a simple table with employee data (office number and name), with two entries of any type
  - Ensure that Black Team can check queries
  - Report concerns
  - Monitor logs and immediately report attacks against the system to the Co-Captain
- **Mary** (Temporary Team Lead / Windows):
  - Install Windows Server 2016
  - Pull Windows Server 2016 secuirty scripts as available
    - Verify
    - Run
  - Pull the Active Directory installation script
    - Verify
    - Run
  - Ensure that Black Team can check Active Directory
  - Report compleition of Windows Team items to Captain
  - Monitor logs and immediately report attacks against the system to the Co-Captain
- **Fabrizio** (Co-Captain / Infrastructure):
  - Visability with SecurityOnion
  - Support git script typing
  - Ensure inject and incidence response reports are written
- **Uriah** (Captain / Networking):
  - Support networking efforts

## Group Scenario Debrief (7:30 - 8 PM)

### High-Level Overview

* Team work:
  * overall, good communication
  * yelling from across the room worked
* Uriah Noticed: team leaders had little knowledge of what other team members were doing
  * need to communicate better with team Leads
* Uriah: Initial plan was to have CentOS and Windows Server already up and running.
* The CEO/boss of the company will be asking team leads about progress and status of different teams
  * Team leaders should know what everyone on their team is working on every 5-10 minute intervals

### SOP

* Formalize a standard checklist
  * make sure our VMs, network equipment, etc. are plugged in
* Uriah: see and call method
  * read an item off the checklist, point to it, and yell check out loud

### Deliverable for next Monday (Dec. 2)

* Four deliverables
* Change team leaders
  * Windows: Rose
  * Linux: Chris
  * Networking: Grace
  * Infrastructure: Fabrizio
* Have one deliverable for each teams
* Team leads should give Captains what their teams should work on the most by tomorrow (Tues 11/26 By 12 PM)
  * Services:
  * Windows: MySQL, Apache, Windows Server 2016
  * Linux: SSH, Apache, VPN, Mail, 5th service?
    * Focus on **SSH** and **APACHE**

### Sashank

* Are services not working because they are being attacked?
* Maybe we shouldn't attack the services next week
* Vlad was performing a MitM attack
* Do we know how to check routing tables?
  * This is something to look into
* To Vlad: Focus on specifc IP addresses
* To Fabrizio: Know about metasploitable things
  * Purposely vulernable VMs
  * This will add to the multi-tasking component
  * This adds more stress
  * Try to patch this, but more importantly, know your VM got hit and report incidents

## Windows

### Rose

* Finished installing Windows Server
* Struggled with installing MySQL
  * (failed) to get MySQL up and running
  * ran into a package issue
  * found a better installation method for next week

### Mary

* Installed Windows Server 2016 from scratch (successful)
* Red team could not test against service (service seemed up and running)
* Used Windows Server 2016 ISO

## Networking

### Grace

* Objective:
  * obtain an IP address from a DHCP server (success)
  * tried to set up a DHCP server on our own router and assign an IP address to a PC and our network (success? - unclear)
* Forgot to plug in switch
* Turned on the switch after the DHCP server was set up
* Tried pinging to see if it was set up properly
  * did not set up IP address on a port connected to the switch - if this was done, then the setup might have been successful
* Served DHCP, but no gateway was set up
* look into Cisco IOS scripting language
  * be able to script different procedures and work on all Cisco routers
* Sashank: **Look into Cisco packet tracer
  * this will help because it gives a console (emulator)**

## Infrastructure

### Brad

* Objective: Set up a git server (failed)
  * due to lack of experience

### Fabrizio

* Saw network scans, brute force attacks, packet resets
* Received SSH packets from IP addresses 72 and 92
* Had to use Wireshark on Windows because security onion is installed differently on school machine and personal laptop

### Zach

* Objective: Write inject and incident reports
* Need to prioritize what are the most important reports to write
* Need a standardized structure for writing reports

## Linux

Possible injects:
* Install Apache chat room, chat bot, or live chat
  * Most likely we will be given some code with vulnerabilities and we are expected to find and fix them

### Chris

* Objective: Get SSH running on CentOS (failed)
* SSH seemed up and running, but there was no authentication with check user
* Sashank: Did you check your logs, tried verbose, or tried to SSH into your own machine? - No
* Chris noticed a brute force attack
  * Did not report it to Fabrizio (may be overkill)
  * In a real scenario, this is important for an incident report

### Joel

* Objective: Install Apache (failed)
* Got Apache to work internally
* Another service was running on host machine
  * Checked the version number from the service running - It was different
* CHECKLIST: Know what services are running on your host machines already
* Looked at httpd log
* Maybe port forwarding should take precedence
