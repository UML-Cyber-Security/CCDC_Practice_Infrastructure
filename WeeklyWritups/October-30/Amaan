Amaan Jamil
10/30/23 Writeup

My task once we started was to get docker set up on our linux machines and have some way to manage our containers.
Portainer was my reccomendation for this since it had a nice gui interface but I was helping out the guys working on the
apache and nginx servers so I only got aas far as getting docker on 2 of the machines and I never ran the portainer interface.

Since we kept on getting logged out of the machines and resources were being used up I took over the linux1 machine and tried to increase it's uptime.

The first thing I did was turn off ssh and any other daemons that I couldd find that would potentially give them easy access to the machine.
Then I did a ps -auxf to give me a process tree and I saw that there processes with an open shell and proccesses looking at our authorized keys so I killed off
those proccesses.
The last thing I did was look in the password file and I saw there were a bunch of random users added so I removed them and then turned ssh back on.


In between meetings I'm going to be setting up portianer along with coming up with a basic set of instructions on what to do to harden a machine.
I realized either we don't have the documentation for what to do in the 20 minutes before we get attacked or I don't know where it is so I'm going to 
come up with something along with having a quick reference manual on what things do since I really needed that during this past practice.