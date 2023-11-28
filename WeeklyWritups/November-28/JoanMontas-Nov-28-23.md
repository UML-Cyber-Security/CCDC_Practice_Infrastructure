# Write-up: Blue Team (SIEM)

## Overview
Name: `Joan Montas`

### What We Worked On:
- Installed Wazuh from scratch. We used a new machine, with the Ubuntu Server rather than Desktop.
    We thought it would be more suited for its purpose.
- Setup File Integrity Monitor in key locations.
- Reconfigure agents after the newly built image.
- Install audit.d as a backup.

### Challenges Faced:
- The SIEM machine was having memory issues. We had not install anything out of our usual.
    Some digging aroun I found that we needed to clear some log file and an extra grub/kernel
    perhaps after updating the image we had.
    Ultimately a new machine was built due to the lack of time.
- Iptable mis-configuration left us blind.

### Future Plans:
- Gain competence on networking. Wazuh was rendered useless after some changes to the IP table.
    An incident responce was submited. In such situation, do a little research and ask network savvy team mate.
    In such case, next time, we could have use audit.d to see what had happen
- Layout our architecture, see the big picture; What is connecting to what, how and why.
- Research tools for active reponse and can be interfaced via Wazuh.
