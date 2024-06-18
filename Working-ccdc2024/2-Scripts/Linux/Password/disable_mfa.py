from os import system

def disableMFA(usernames):
    for user in usernames: 
        system(f"sudo usermod -a -G disable_mfa {user}")

        
def addGroup(group_name):
    system(f"sudo groupadd {group_name}")
        
if __name__ == "__main__":
    group_name = "disable_mfa"         
    disable_group = []
     
    with open("disable_mfa.txt", "r") as mLog:
        usrs = mLog.readlines()
        for usr in usrs:
            disable_group.append(usr.rstrip())   
            
    if len(disable_group) != 0:
        addGroup(group_name)        
        disableMFA(disable_group)
	
	lines = open("/etc/pam.d/sshd", "r").readlines()        
        with open("/etc/pam.d/sshd", "a") as pLog:
            if lines[len(lines) - 1] == "":
                pLog.write(f"auth [success=done default=ignore] pam_succeed_if.so user ingroup {group_name}\n")
            else:
                pLog.write(f"\nauth [success=done default=ignore] pam_succeed_if.so user ingroup {group_name}\n")
        
