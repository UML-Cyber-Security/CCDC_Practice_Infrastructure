# Nov 13 2023 Writeup <!-- omit from toc -->
This is a writeup for the aforementioned date above it is organized into the following 
- [Progress](#progress)
- [Observations](#observations)
- [Improvements/Reflection](#improvementsreflection)

## Progress 
Not much:
1) I wrote a basic guide on "What to do in the first 10 mins" so people would hopefully be able to do some steps on their own.
2) I wrote some basic scripts to help people with management (SUID Binary search and User Search)
   1) We can probably add some for listing network connections and whatnot
   2) Maybe make it so we can more easily change passwords
   3) HOW CAN WE SEARCH SYSTEMD STUFF
3) I defended teleport, I was tired and am always tired. I sat on my machine, and answered a few questions that other people had. Easier to do stuff when you can access it and see that it is being attacked (STRESS)
4) People seemed a bit more engaged
5) Don't think injects were done

## Observations
1) Injects were not really done, the assignment of those injects was a bit odd. 
2) Time keeping was not done. 
3) Kicking off users is hard where some unknown service is adding them
4) SOC is important, quite hard to do much in terms of remediation when the SOC server and agents are down. Not their fault, but it just makes it more difficult.
5) Firewalls are a bit important, kicking off users before doing it is even more so.
6) Passwords when Justin seems to really like password loggers is scarry, can we avoid them?
## Improvements/Reflection
1) I am curt, Not really doing injects or incident responses since they are long, tedious and in my opinion not worth it at times. Can we streamline this in any way.
   1) Would it be possible to pre-write some fluff and keep it in the Github repository so we can have some cookie cutter response to things we know will happen? like

    ```
    We found unauthorized users x,y,z. These were not created by the system administrators and are not on any authroized user's list. They own the files x,y,z and we have observed x logged in. Our preliminary step is to lock the users and kick off any logged in session. ect 
    ```
2) How can we avoid authorized keys from being possible. Seems like a good bypass, we also therefore need to protect the sudoers file.
3) Can we create a new account, and make it so that account does not need a password if we suspect there is a keylogger?