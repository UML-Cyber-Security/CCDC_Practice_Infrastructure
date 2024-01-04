# 11/7 - Week 4 Writeup

---

Alex Sheehan


---

## Experience

No pfsense to deal with == the world is a good place.

---

## Meeting Prep 

- Removed pfsense
- Moved vms to main network. Reconfigured IPS.
- Re-configured teleport agents / teleport client for new network. 
- k8

## Meeting

Securing team1teleport

Found authorized file at /var/lib/udisks2/authorized_keys
commented for now 

permitemptypassword is allowed, disabling

permitrootlogin allowed.

changed port to 42000

Checking shadow file,

Root has password.
team1 has password.
srv-sysmon has password.
services has password.
srv-docker has password.
alice has password.
bob has password.
eve has password.
srv1 has password.

Removing all.

They removed 2fa for teleport and removed my permissions.
Removed 
    
    2 factor: "no"

and restarted service.

For teleport, my account was removed from admin.

Created new temp user alex temppass123

Deleted users
JustinIsGreat1-9
LOL 

---

## Whats next

- check out hashicorp
- more orc

---

## Challenges

- matt uninstalling vim

