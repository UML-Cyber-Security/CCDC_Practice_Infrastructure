Leonard Nguyen
10/30/23 Writeup

Work Before Monday:
The week prior to 10/30/23's meeting was spent figuring out exactly what I needed to do with a task I was given to build our infrastructure.
In that week, I picked up where we left off, setting up an nginx proxy in the machine called Team1DNSProxy. For that, I had to ask around and try
to get to know my teammates, which lead me to a Youtube video Sashank posted in the CCDC Discord. From there, assuming I understood what I was
supposed to be doing, I wrote a configuration for nginx. However, in hindsight, I probably should've installed nginx and did all the configurations
in a docker container on some other machine...? Maybe? It's also worth noting that Chris showed me what a proxy does, so that simplified my concerns.

Blue Team Monday:
My task was to start up an Apache webserver for Phase 2. For that, I needed to learn basic Docker commands on the fly, so I ended up needing to
ask Amaan for help with the majority of the work. As he installed docker, Riley and I ran the commands Amaan gave to us to to run our containers
for nginx and apache. The commands were:

sudo docker run  -p 8080:80 -d nginx
sudo docker run -p 8081:80 -d httpd

with nginx running on port 8080 and apache running on port 8081.

From then on, I just stopped what I was doing and tried logging in to the two machines I'm most familiar with, Team1DNSProxy, and Team1-Linux2. I
gathered, according to hints from discord, Chris, and some files from the etc folder, that there were some odd users logging in to our system. We
also got a message regarding a man in a middle attack, which was apparently how the Red Team got our fingerprint...?

Going forward, I'll be looking into docker tutorials and do a bit of searching on Portainer, which looks like what we'll be using to manage our
webservers.

Video Sashank sent in the CCDC Discord:
https://www.youtube.com/watch?v=DyXl4c2XN-o
