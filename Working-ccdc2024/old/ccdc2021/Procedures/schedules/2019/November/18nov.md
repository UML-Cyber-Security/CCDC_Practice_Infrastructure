# November 18<sup>th</sup> Training Schedule:

## Deliverables prepared for practice:
- Chris
  - Complete Ubuntu Snort service documentation added to `Ubuntu/services/snort/README.md` per Vlad's review
- Liam
  - CentOS fail2ban service documentation added to `CentOS/services/fail2ban/README.md`
- Rose
  - Complete Windows Server 2016 installation documentation added to `WindowsServer2016/installation/README.md` per Vlad's review
- Vlad
  - Create a script that checks the availability of SSH, apache, MySQL, active directory, and mail, added to `Documentation/practice/score/`
- Zach
  - Complete Windows10 Apache server documentation added to `Windows10/services/apache/README.md` per Vlad's review

## SOPs to keep in mind:
- Task primers received and processed ahead of time
- Double check your work ***before*** pressing `enter`
- Ensure file integrity
- Map workstations and IPs

## 5:30pm - 6:15pm, Webinar 

## ??? - Announcements
- The right way to miss practice
- Shout to Rose and Grace for documentation attempts
- Team Lead concept
- Winter break sessions
- Saturday dinner

## ??? - 6:15pm, Time filler
- If time allows
  - Discuss any strategy changes
  - Upload notes from webinar
  - Spend extra time on group scenario-- jump to inbrief

## 6:15pm - 6:30pm, Group Scenario inbrief

## 6:30pm - 7:30pm, Group Scenario

**Setup**: 

Remove computers from network (unplug their ethernet cables)

**Scenario**:

The IT team needs to put up a secure SSH, Apache, mail, and MySQL server, along with Windows Active directory. 

## Roles:

- **Vlad** (Black/Red Team)
  - Publish tested IPs / ports for the ssh, apache, active directory, and mail services
  - Create the "string" being checked for on apache
  - Create the public key for the ssh check
  - Create a small MySQL table to query
  - Begin checking for ssh, apache (linux), MySQL (windows), active directory, and mail services (linux)
  - ???
  - Profit
  - Attack and cause **d̮̻̲͉̘ͮͧ̽͐ͤam̱̺̗͕̠̱̄̂̂͛ͬ̑a̪̹̹̐̉͊g̠̘͓e̴͖̩͍̔̈́͌**
  - Do a flip
- **Yassir** (Infrastructure):
  - Install Alpine Linux
  - Install a git server
  - Establish Username/Password authentication
  - Verify repo is accessible
  - Secure git server with some key based authentication
  - Install an ftp server
  - Download commonly used ISOs (CentOS, Alpine) for future distribution
  - Ensure private services are within the DMZ and not accessible to Vlad
- **Unassigned** (Linux):
  - Install CentOS
  - Install OpenVPN
  - Enforce public key encryption only
  - Ensure that the VPN is accessible by Vlad (not currently a checked service)
  - Monitor logs and immediately report attacks again the system to Co-Captain
- **Liam** (Linux):
  - Install CentOS
  - Install Apache
  - Retrieve a unique string to place in a website from Vlad
  - Ensure that apache is being "checked" by Vlad
  - Monitor logs and immediately report attacks again the system to Co-Captain
- **Chris** (Linux):
  - Install CentOS
  - Install ssh
  - Retrieve a public ssh key from Vlad
  - Ensure that ssh is being "checked" by Vlad
  - Monitor logs and immediately report attacks again the system to Co-Captain
- **Joel** (Linux):
  - Install CentOS
  - Install a mail server
  - Ensure that mail is being "checked" by Vlad
  - Monitor logs and immediately report attacks again the system to Co-Captain
- **Grace** (Networking):
  - Set up the router to connect the Internet (lab networking equipment), public services, and the DMZ
    - The DMZ will contain the git server
    - Public services include mail, Apache, and SSH
    - The internet is just connection back into the lab back bone
- **Rose** (Windows)
  - Install Windows Server 2016
  - Install MySQL 
  - Create a simple table with employee data (office number and name), with two entries that
  - Ensure that Vlad can check queries
  - Monitor logs and immediately report attacks again the system
- **Mary** (Windows):
  - Install Windows Server 2016
  - Install Active Directory
  - Ensure that Vlad can check Active Directory
  - Monitor logs and immediately report attacks again the system to Co-Captain
  - **Unassigned** (Windows):
  - Install Windows Server 2016
  - Install Apache
  - Ensure that Vlad can check the website
  - Monitor logs and immediately report attacks again the system to Co-Captain
- **Fabrizio** (Co-Captain / Infrastructure):
  - Install SecurityOnion
  - Work with Networking team to hook into a mirrored port
  - Monitor network traffic and immediately report attacks against the network
  - Develop a written incident response report for any attacks
- **Uriah** (Captain / Networking):
  - Set up the firewall to place between the router and Internet (lab networking equipment)
  - The firewall should mitigate any obvious DoS attacks
### 7:30pm - 7:45pm, Group Scenario Debrief
