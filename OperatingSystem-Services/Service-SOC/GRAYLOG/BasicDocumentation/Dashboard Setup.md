# Basic Dashboard setup #

WHAT THIS IS:  
What is this desc. here.

## Quick Guide ##
For Linux:

New Linux user or group --> application_name == useradd (info needed message and source)
User or group deletion --> application_name == userdel (info needed for message and source)
Any ssh alerts --> application_name == sshd and facility == security/authorization
- regular login: facility_num == 10
- key logins: facility_num == 4

New root/sudo session --> application_name == sudo and facility == security/authorization (facility_num == 10) (message for info)



GROK extractor

Field contains: Accepted password
Accepted password for %{USERNAME:user} from %{IP:source_ip} port %{NUMBER:port} ssh2

