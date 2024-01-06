# Welcome 

Hey there! This is a simple getting started guide for Hack the Box (HTB) that goes over some general tips and some useful tools that you might want to use for your first exploits on the boxes. 

Let's get started!


## Why HTB? 

Excellent question! The answer is because it's awesome. It provides a great way to allow you to teach and practice the art of red team hacking. The only true way to defend a system is to first break in to it and understand exactly how your opponents will use the same techniques to get into your systems. 

From there, it's as simple as blocking these tactics and boom, you've got yourself a secure system. 


## How to HTB?

Your first box might seem scary to attempt, but after a while, you'll get the hang of it and it'll become a second nature, so just hang in there! 

### The Three Steps of HTB 

There are generally three steps you're going to want to go through to get into a box. 


**First, Probe.** This step is all about analyzing your target and trying to figure out what it does, what it runs, what might be vulnerable and what not, etc. This is the largest step and where most of your time might be spent. 

**Second, Exploit.** During this step, you use the information you gathered previously to find an exploit that will allow you to get into the system. 

**Third, Privilege Escalation.** This step is what takes you from having a foothold on a system to being the owner of the system. During this step, you'll be escalating your foothold (which will probably be some service you hacked running with normal privileges) to give you full admin privileges.  


### Tip: Add IP to Host File

A helpful idea is to add your box's IP to your host file. Sometimes this is required as the boxes make references to specific hostnames. You can do this by doing the following: 

```echo "<ip> <boxname>.htb" | sudo tee -a /etc/hosts```


Adding a ".htb" to the boxname is advisable. Additionally, I've included a helpful script to this repo that allows you to run the following command instead: ```./add_hosts.sh <ip> <boxname>.htb``

## Tools 

There are a couple of tools you're going to want to have in your toolbox. Every box might require different specific tools, but more likely than not, you'll be able to use a lot of the same general tools. 

### Step 1 Probing Tools

#### Nmap

You'll probably end up using this tool first. Nmap stands for Network MAPer. It allows you to scan an IP address or host for open ports and give you details about the open ports. With the right flags, Nmap can be a deadly force against the machine you're probing. 

A simple Nmap command will look like this: ```nmap -A <ip>``` 

For a more comprehensive list of Nmap flags, please take a look at this searchable cheat sheet: https://www.stationx.net/nmap-cheat-sheet/.

#### Nikto

Nikto is a website scanning tool that allows you to get important information from a website.  

A simple Nikto command will look like this: ```nikto -h <ip>``` 

Check out this cool cheat sheet for Nikto commands: https://cdn.comparitech.com/wp-content/uploads/2019/07/NIkto-Cheat-Sheet.pdf. 

#### HTTP Analyzer: Burp Suite or Hetty

This kind of tool allows you to intercept webpages and analyze them as well as sending information to them to help you probe and document how they work. You have a couple of options, mainly Burp Suite and Hetty. Burp Suite is a full application that you install on your computer that comes with a user interface. It has a steeper learning curve and also is a paid software (but has a community version that you can get for free but with less features). 

Hetty is an opensource software that does the same purpose but runs as a web interface on your machine. It has less of a learning curve and doesn't have any liscence requirements. Might not be as feature-full as Burp Suite, however. Check it out over here: https://github.com/dstotijn/hetty.



### Step 3 PrivEsc Tools 

#### PEASS-ng (Linpeas/Winpeas/etc) 

Stands for "Privilege Escalation Awesome Scripts SUITE new generation." It's a simple enumeration script that goes over a bunch of common priv esc vulnerabilities that you'll find on many systems. It's a great start for trying to figure out where to hit on a system. 

Check it out here: https://github.com/carlospolop/PEASS-ng.

#### Pwnkit.sh 

According to [DataDogHQ](https://www.datadoghq.com/blog/pwnkit-vulnerability-overview-and-remediation/), "The PwnKit vulnerability allows users to run the PolicyKit executable pkexec , passing it a specific set of environment variables that cause an arbitrary library file to be loaded. As a consequence, an underprivileged attacker can invoke PolicyKit and trick it into executing an attacker-controlled." 

Check out a Proof-of-Concept (POC) over here: https://github.com/ly4k/PwnKit.

