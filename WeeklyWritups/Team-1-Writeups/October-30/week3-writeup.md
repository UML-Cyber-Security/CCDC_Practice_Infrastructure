# 10/31 - Week 3 Writeup

---

Alex Sheehan

---

## Experience

Haha! It was enjoyable.

---

## Meeting Prep 

I setup the pfsense router.

### PFSENSE Setup Alterations compared to github.

- Step 4 -> ccdc2024storage not local

- on first boot setup 
  - step 3/4 
    - Was prompted for an OPT1 network (assumed this was the DMZ network to attach)

- Just did default install
  - set the lan to the priv network we described.

I ran out of time, did a brute force DMZ

- Allowed anything on dmz with ip 10.1.20.1/24 to access https on lan.



### Network Setup 

Firewall IP   ->    192.168.0.79
Internal LAN (Firewall ip as well)  ->    10.1.10.1/24 
DMZ LAN       ->    10.1.20.1/24 

#### IP Assignments


##### LAN 
Team1-Linux1    ->    10.1.10.20/24 
Team1-Linux2    ->    10.1.10.21/24
Team1UbuntuSiem ->    10.1.10.22/24

Team1WindowsAD  ->    10.1.10.30/24
Team1WindowsServer -> 10.1.10.31/24
T1-W2           ->    10.1.10.32/24

##### DMZ 
Team1Teleport   ->    10.1.20.15/24
Team1proxydns   ->    10.1.20.16/24 


#### Port forwarded ssh access 

Team1-Linux1    ->    ssh -p 53000 team1@192.168.0.79 
Team1-Linux2    ->    ssh -p 53001 root2@192.168.0.79
Team1teleport   ->    ssh -p 53002 team1@192.168.0.79
Team1proxydns   ->    ssh -p 53003 team1@192.168.0.79

#### Port forwarded other access

Team1teleport   ->    https://192.168.0.74:52000
Team1proxydns   ->    https://192.168.0.74:52004
Team1proxydnswebsite   ->    http://192.168.0.74:52005



#### BRO BRO BRO if you are on proxmox 

Advanced->Networking check the Hardware checksum offloading box

- Followed normal install already in github.
- Once loaded in, pressed 2 to set the interface ip addresses
  - vtnet1 (our lan)
    - 10.1.10.1/24 
    - no dhcp , no ipv6, enter wherever it says you can press enter to continue.
  - vtnet2 (our dmz)
    - same as above, but 10.1.20.1/24 
- press 8 to go to shell, need to disable firewall to be able to access from WAN side.
  - pfctl -d 
- navigate to https://192.168.0.74
  - default login -> admin/pfsense
- Go through setup wizard
  - On WAN page, just leave as DHCP.
  - At bottom, uncheck bottom 2 boxes (bogon and internal)
  - set the dns servers to 1.1.1.1 and 1.0.0.1

Firewall rules 

- Firewall->WAN 
  - allow https (443) from anywhere

- Services->DHCP 
  - Enable DHCP server for LAN and OPT1 
  - If needed to provide range, just do x.x.x.10->x.x.x.245

---

Then, i setup teleport on the internal linux machines. Key thing to note, when you are portforwarding access to a teleport, and trying to manage it from WAN side, you need to alter your approach for the teleport setup on nodes. First, the link it gives you to deploy on machines will provide the `router ip`. Change this to the internal ip of the teleport machine (also remove the port.). If errors with curl, add -k to the flags. 

## Meeting

- PFsense decides to completely stop working 2 minutes before start time. (After working perfectly all night and morning btw.)
- Miserably did the firewall for first hour 
- proceeded to get locked out of firewall ui (arp issues i guess from red team changing forwarding address.)
- Started checking pfsense machine 
  - cat /etc/passwd 
    - 3 weird users, deleted.
      - pw user del toor
      - pw user del Sashank
      - pw user del test 
- found some weird firewall rules
- using to delete rules via cml on pfsense.
  - pfctl -a wan_rules -F all
- using to add rules via cml on pfsense
  - pass in on <WAN_INTERFACE> proto tcp from any to any port 443
- Majority of time was spent keeping the firewall from divebombing.


---

## Whats next

- Need to check teleport and pfsense machines for exploits from red and remove.

---

## Challenges

- Pfsense. . . . . . <<<<<< . . . <<<<



