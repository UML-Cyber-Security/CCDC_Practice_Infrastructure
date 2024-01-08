from os import system
pam_append_lines = ["auth required pam_google_authenticator.so nullok", "auth required pam_permit.so"]

if __name__ == "__main__":
    system('google-authenticator')
    
    pLog = open("/etc/pam.d/sshd", 'r')
    lines = pLog.readlines()
    pLog.close()
    
    with open("/etc/pam.d/sshd", "a") as pLog:
        if lines[len(lines) - 1] == "":
            pLog.write(pam_append_lines[0] + "\n")
            pLog.write(pam_append_lines[1] + "\n")
        else:
            pLog.write("\n" + pam_append_lines[0] + "\n")
            pLog.write(pam_append_lines[1] + "\n")
            
    system('cp /etc/ssh/sshd_config /backups/configs/sshd_config_1.bak')
    
    with open('/etc/ssh/sshd_config', 'r') as sLog:
        original_config = sLog.readlines()
        with open('/etc/ssh/sshd_config', 'w') as rLog:
            for line in original_config:
                if "ChallengeResponseAuthentication" in line:
                    rLog.write("ChallengeResponseAuthentication yes\n")
                else:
                    rLog.write(line)
    
    system('sudo systemctl restart sshd.service')
    
    sLog = open('/etc/ssh/sshd_config', 'r')
    lines = sLog.readlines()
    sLog.close()
    
    with open('/etc/ssh/sshd_config', 'a') as sLog:
        if lines[len(lines) - 1] == "":
            sLog.write("\n")
        sLog.write("AuthenticationMethods publickey,password publickey,keyboard-interactive\n")   
    
     
    with open('/etc/pam.d/sshd', 'r') as pLog:
        original_config = pLog.readlines()
        with open('/etc/ssh/sshd_config', 'w') as pLog:
            for line in original_config:
                if "@include common-auth" in line:
                    pLog.write("#@include common-auth\n")
                else:
                    pLog.write(line)
                    
    system('sudo systemctl restart sshd.service')
    
           
           
