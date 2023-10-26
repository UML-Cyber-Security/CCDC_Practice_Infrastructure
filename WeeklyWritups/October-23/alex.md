# 10/24 - Week 2 Writeup

---

Alex Sheehan


---

## Experience

Against normal belief I enjoy having to adjust a strategy when random stuff happens, so it was fun when stuff didnt go as originally planned. 

---

## Meeting Prep 

- Created some scripts for linux 
  - Randomized User Creation
  - Wiping user hashes creating passwordless accounts
  - SSH key copy and file transfer
  - SSH compromise to configuration file 
  - Systemd service/timer files for some of above
- Windows
  - Dear lord do I wish they coulda seen the duck.
    - Duck and rickroll powershell script. 


## Meeting

- Started by attempting to get into teleport. (didnt) 
- Realized we had 2 minutes left, didnt have time to run automated scripts I made. (sadface)
- Did some reconissance with nmap on their subdomains
  - nmap -sV 10.0.2.1/24 , nmap -sV 192.168.0.1/24 , nmap -sV 192.168.2.115 , nmap -sS 192.168.2.115 
- Only revealed their ssh ports switched to 2222, login page for pfsense and the console pages justin installed.
- After we were allowed to start doing stuff again, ran script, got into rocky 1 and 2 
but they werent being used.
- The scripts were deployed on there tho, so someone might want to give that a check..
- With remaining time, started hydra dic attack on router with username root. (no) 
  - hydra -l root -P .local/share/wordlists -s 2222 <ip> ssh

---

## Whats next

- Going to go learn `deployment service` real quick.
- Deploy subnet/s and segmentation?
- Start getting teleport access to servers.

---

## Challenges

- Need to learn how teleport + CA works <<-


