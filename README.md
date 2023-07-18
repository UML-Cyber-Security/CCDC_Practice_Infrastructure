# CCDC Practice Infrastructure <!-- omit from toc -->
This file will contain basic information on 

1. Hyperlink to Topic Directories
2. Taiga Access 
3. PFSense Access


Any information regarding the setup and use of the infrastructure, or any related scripts will be located in their related subdirectories.

A style guide for this repository is provided in the [Markdown_Style](./Markdown_Style.md) file. It is likely not followed but it also contains some useful programs, and software when interacting with GitHub and Markdown.

## Table of Contents (README) <!-- omit from toc -->
- [Table of Contents (TOPICS)](#table-of-contents-topics)
- [Taiga Access](#taiga-access)
  - [Login/Register](#loginregister)
  - [Access Project](#access-project)
  - [Access Epic](#access-epic)
  - [Access Sprint](#access-sprint)
  - [Access Wiki](#access-wiki)
  - [Access Issues](#access-issues)
- [PFSense Access](#pfsense-access)
  - [System Info](#system-info)
  - [Steps to Access](#steps-to-access)

## Table of Contents (TOPICS) 
* [Proxmox Setup](./Proxmox/README.md)
* [Gluster](./Shared_Filesystem/Gluster/README.md)
* [NFS](./Shared_Filesystem/NFSserver/README.md)
* [Network](Network/README.md)
  * [PFSense](Network/PFSense/README.md)
  * [Proxmox Networking](Network/Proxmox/README.md)
* [Linux](Linux/README.md)
  * [Teleport](Linux/Teleport/README.md) 
* [Windows](Windows/README.md)
  * [Deployment](Windows/Deployment/ProxmoxSetup.pdf) 

## Taiga Access 
If you are looking at this in the far future (or even the near future), then its likely the Taiga will not exist or be useful. Hopefully, we are able to preserve the Wiki entries somewhere here!

Otherwise the following are instructions on how we can access Taiga.
### Login/Register
1. Utilize the OpenVPN Certificate you have to access the CyberRange network. A successful connection is shown below. Contact someone (known at the time) to get a certificate if you do not have one.
    
    <img src="Images/Taiga-OpenVPN.png" width=200>
2. Open a web-browser and navigate to [https://taiga.cyber.uml.edu/](https://taiga.cyber.uml.edu/). Unless you have a Cyber-Range TLS Certificate in your trusted certificate store you will see a warning as shown below. This will vary from browser to browser (Microsoft Edge is shown below).
    
    <img src="Images/Taiga-Warning.png" width=800>
3. Acknowledge the warning if there is one.
    
    <img src="Images/Tiaga-Continue.png" width=800>
4. If you are not logged in, you should see the blank login screen below.
    
    <img src="Images/Taiga-Home.png" width=800>
5. If you have an account click **Login** at the top right and enter your information.
    
    <img src="Images/Taiga-Login.png" width=800>
6. Otherwise click **Register** at the top right and fill in all fields.
    
    <img src="Images/Taiga-Register.png" width=800>

### Access Project
1. We assume at this point you have both created a Taiga account and logged in. You should see something like the following.
    
    <img src="Images/Taiga-Home-Logged.png" width=800> 
2. Additionally you should be added to a Project by one of the other users (admins). Once you are added to the project go to the top left and click projects. You will see something like the following.
    
    <img src="Images/Taiga-Projects.png" width=800>
3. Click on the project that you would like to access, you should see something like the following. Notice the additional options on the Left.
    
    <img src="Images/Taiga-Project-Home.png" width=800>

### Access Epic
1. Click on the Epic tab on the *left*, it is highlighted below.
    
    <img src="Images/Taiga-Project-Home-Epics.png" width=800>
2. Once this is done you should see all the epics (Top Level Tasks) in the project. An example is shown below.
    
    <img src="Images/Taiga-Epics.png" width=800>
3. Click on the Epic and you will be able access and create User Stories as shown below.
    
    <img src="Images/Taiga-Epic-Internal.png" width=800>
4. We can then click on an existing User Story to add individual tasks as shown below.
    <img src="Images/Taiga-User-Story.png" width=800>
    * From this we can leave notes and access the tasks. Tasks are the smallest unit of organization, we cannot subdivide further and only one user can be assigned (in Taiga) to a task.

### Access Sprint 
1. Click on the Scrum tab on the *left* it is highlighted below.
    
    <img src="Images/Taiga-Project-Home-Sprint.png" width=800>
2. From this we will get a drop down and can select a Sprint or access *Backlog* from which we can create a sprint and add user stories (By dragging and dropping to the right)
    
    <img src="Images/Taiga-Sprint-Drop.png" width=200>
3. The Backlog allows us to add User Stories to the sprints displayed on the *right* side of the screen. We can also access the sprints from the list on the *right*
    
    <img src="Images/Taiga-Sprint.png" width=800>
4. The internal page once we have selected sprint is shown below. We can see the User Stories and their related tasks. We see a Kanban board that we can move tasks around, and add tasks to the user stories.
    
    <img src="Images/Taiga-Sprint-Internal.png" width=800>

### Access Wiki 
1. Click on the Wiki tab on the *left* it is highlighted below
   
   <img src="Images/Taiga-Project-Home-Wiki.png" width=800>
2. Once we have done that we can see the Main Wiki Page for the Project

    <img src="Images/Taiga-Wiki.png" width=800>
    * On the left we can see Bookmarks (Pages) and once we have selected them we can leave notes, attachments, and see the previous edit history

### Access Issues
1. Click on the Issues tab on the *left* it is highlighted below
    
    <img src="Images/Taiga-Project-Home-Issues.png" width=800>
2. From here we can click "New Issue" button on the top right
    
    <img src="Images/Taiga-Issues.png" width=800>
3. Once we have done so, we can fill out the issue with the topic and necessary information. You can assign it to a user or ask someone else to do so.
    
    <img src="Images/Taiga-Issue-Internal.png" width=800>

## PFSense Access 
### System Info
Proxmox Infrastructure Reference
| PC Number | Hostname | IP |
| --------- | -------- | -- |
| WAN-35    | Proxmox5 | [192.168.0.114](https://192.168.0.114:8006/#v1:0:18:4:5:=contentIso:::::5) |
| WAN-36    | Proxmox4 | [192.168.0.87](https://192.168.0.87:8006/#v1:0:18:4:5:=contentIso:::::5) |
| WAN-37    | Proxmox3 | [192.168.0.118](https://192.168.0.118:8006/#v1:0:18:4:5:=contentIso:::::5) |
| WAN-38    | Proxmox2 | [192.168.0.159](https://192.168.0.159:8006/#v1:0:18:4:5:=contentIso:::::5) |
| WAN-40    | Proxmox1 | [192.168.0.223](https://192.168.0.223:8006/#v1:0:18:4:5:=contentIso:::::5) |

(Currently has the Cluster has been started with the above information)

Please refer to the [Taiga Wiki](https://taiga.cyber.uml.edu/project/ccdc-2024-team/wiki/practice-infrastructure) for the login information. Although you can likely guess this information.

### Steps to Access
1. Connect to the OpenVPN server using your certificate. This requires the [OpenVPN Client](https://openvpn.net/client/)
2. Access one of the Instances using their IP. 
    * The Proxmox web interface is hosted on the port **8006**
    * **Note**: The IP's in the table above provide hyperlinks
3. Login using the information on the [Taiga Wiki](https://taiga.cyber.uml.edu/project/ccdc-2024-team/wiki/practice-infrastructure)
    * This is the usename and password
4. Now you have access, it is quite simple I would think
