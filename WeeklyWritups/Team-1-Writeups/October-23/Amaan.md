Amaan Jamil
10/23/23 Writeup

I was not a part of any team before this week since I was sick and unfortunately there was not an AWS component I could work on

The first thing we noticed was that both Rocky 1 and 2 still had their default credentials for the root user so
I created SSH keys for the root user and stored that on my personal machine. I also created a new user called red team with sudo access so 
if they disabled root loging via ssh I had another option.

I also scanned what was available on the network using nmap and we found the pfsense router. I scanned the router to see what ports were open and we
found and nginx server, a portainer instance, and the pfsense interface. unfortunately our backdoors did not work so we weren't able to

It was interesting joing the red team w/o anything since I had no scripts set up but I still felt like I was contributing something.

For the up coming week I think I'm working on DNS/Proxy. I'm also going to try to make a general writeup for what to do when you get a system and
what to immediately look for if something is going wrong based off of what I did do the blue team.