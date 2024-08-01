## IAM Project Proof of Concept Setup
*Identity Management POC* will have three virtual machines to simulate the production deployment. One *Keycloak server* as the IAM solution for login management, it will be using *Ubuntu 22.04 Server* . A End-user machine, running the *Cyber-Range* operating system of *Ubuntu 22.04*, with the graphical interface. The end-user machine will be simulating a *Cyber-Range* desktop. For the last Virtual Machine there will be *Windows Server 2019* running *Active Directory Domain Services*  

### **General Overview** 
VM Hypervisor - *VMware*

VM1 (Keycloak) - *Ubuntu 22.04 Server*  

VM2 (End-user) - *Ubuntu 22.04* w/ graphical interface

VM3 (AD Domain Services) - *Windows Server 2019*  w/ graphical interface

## Windows Server (VMware Setup) 
A Windows Server will be needed in this PoC. You can get the *Windows Server 2019* iso from the [official website](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2019).

1. Top left to create a new virtual machine
   
   <img src="Images/A1.PNG" width=750>

2. Choose "I will install the OS later"
   
   <img src="Images/A2.PNG" width=750>

3. Click *Next*

   <img src="Images/A3.PNG" width=750>

4. Choose drive/location

   <img src="Images/A4.PNG" width=750>
  
5. At least *60 GB's* needed.

   <img src="Images/A5.PNG" width=750>
  
6. Click *Finish*

   <img src="Images/A6.PNG" width=750>
   
7. Now go to the Windows Server VM settings and change the CD/DVD to use the Windows Server ISO 

   <img src="Images/A9.PNG" width=750>
   
8. Go to the Windows Server VM location and edit the vmx file, change firmware to bios 

   <img src="Images/A7.PNG" width=750>
  
9. Power your Windows Server VM on 

   <img src="Images/A8.PNG" width=750>
  
## Windows Server (Active Directory Setup) 
1. On Server Manager select *Manage* in the top right and select *Add Roles and Features*

   <img src="Images/B1.PNG" width=750>

2. Select *Next*
  
   <img src="Images/B2.PNG" width=750>

3. Select *Role-based or feature-based installation*

   <img src="Images/B3.PNG" width=750>

4. Select *"Select a server from the server pool"*

   <img src="Images/B4.PNG" width=750>

5. Choose *AD Domain Services* and then select *Add Features*

   <img src="Images/B5.PNG" width=750>

6. Select *Install*

   <img src="Images/B6.PNG" width=750>
  
7. Close out of installation when finished, then select the warning flag and *promote server to a DC*

   <img src="Images/B7.PNG" width=750>

8. Choose *Add a new forest* and create a *Root domain name*

   <img src="Images/B8.PNG" width=750>

9. Create a *DSRM* password*

   <img src="Images/B9.PNG" width=750>
  
10. Create a *NetBIOS domain name*
    
    <img src="Images/B10.PNG" width=750>

12. Keep defaults and select *Next*
    
    <img src="Images/B11.PNG" width=750>

12. Proceed untill installation is complete and once restarted you have access to Active Directory Domain Service

Adding Users to the Domain

   * Open the Server Manager application, select tools in the top right and select *ADUC*

     <img src="Images/B13.PNG" width=750>
     
   * Right click Users, select New and choose User
  
     <img src="Images/B14.PNG" width=750>
     
   * Fill out user details. For the proof of concept it will simulate a student. 

     <img src="Images/B15.PNG" width=750>

## Keycloak Server (VMware Setup)
1. This virtual machine will be using *Ubuntu 22.04* CLI. The ISO can be downloaded from the [Ubuntu website](https://releases.ubuntu.com/jammy/)

   <img src="Images/C1.PNG" width=750>

2. Once installation is complete you can create a new virtual machine on VMware by selecting *Player* and then *New Virtual Machine*

   <img src="Images/A1.PNG" width=750>

3. Choose *Installer disc image file (iso)* and find path of *Ubuntu Server* ISO

   <img src="Images/C2.PNG" width=750>

4. Create username, full name and password

   <img src="Images/C3.PNG" width=750>

5. Name VM to Keycloak-Server, and pick a file location that has room for 20GB

   <img src="Images/C4.PNG" width=750>

6. Make sure its at least 20GB's for the maximum disk size

   <img src="Images/C5.PNG" width=750>

7. Select Finish and boot up the machine

   <img src="Images/C6.PNG" width=750>

## Keycloak Server (Keycloak Setup) 
Installing Keycloak server
* Update packages
   ```sh
   sudo apt update 
   ```
* Install openJDK 21 
   ```sh
   sudo apt install openjdk-21-jdk
   ```
* Copy raw link (.tar.gz) of the most current version of Keycloak on their [Github Repo](https://github.com/keycloak/keycloak/releases).

    <img src="Images/C7.PNG" width=750>

* Do a wget command for the rawlink you copied in order to get the keycloak.tar file
   ```sh
   wget https://github.com/keycloak/keycloak/releases/download/25.0.2/keycloak-25.0.2.tar.gz
   ```
* Using the tar command unzip the file using the flags -xvzf (extracts, lists out, decompresses and gets filenames)
   ```sh
   tar -xvzf keycloak-25.0.2.tar.gz
   ```
* Before you can access the dashboard you will have to setup the admin account by exporting environmental variables
  ```sh
  export KEYCLOAK_ADMIN=<choose a username>
  export KEYCLOAK_ADMIN_PASSWORD=<something secure>
  ```
* Start the server in development mode in the background using the Keycloak shell command and &
  ```sh
  <file-path/bin/kc.sh start-dev &
  ```
* You can access the dashboard using port 8080 and the host machines IP address, http://keycloak-server-ip:8080

## Keycloak Server (Keycloak Configuration)

1. Create a new realm
   * Go to the top left of the Keycloak dashboard and select the dropdown menu, then select *Create realm*

     <img src="Images/C8.PNG" width=850>
    
   * Create a Realm name and select *Create*

     <img src="Images/C9.PNG" width=850>
    
2. Create a Client for the End User
   * Select *Create client* 

     <img src="Images/C10.PNG" width=850>
     
   * Make sure client type is set to OpenID Connect, add a Client ID 

     <img src="Images/C11.PNG" width=850>
     
   * Set Client authentication to *On* and skip the next page and create the client 

     <img src="Images/C12.PNG" width=850>
     
   * Go to the Clients page on the left side of the dashboard and credentials and copy the *Client Secret* for later

     <img src="Images/C13.PNG" width=850>
    
3. User Federation using Active Directory 
   * Select *Add new provider*, and choose LDAP

     <img src="Images/C14.PNG" width=850>
    
   * Use Command prompt on the Windows Server VM as an administrator and send a dsquery command

       ```sh
       dsquery user -name administrator
       ```
       
   * Choose the Active Directory for the Vendor, replace the Connection URL with the Windows Server IP. For the Bind
     DN you will paste the output of the dsquery command. 

     <img src="Images/C15.PNG" width=850>

   * Select *WRITABLE* for the Edit mode, for the Users DN you will paste the output from the dsquery but remove the    first argument. The rest of the settings should have autofilled. 
   
      <img src="Images/C16.PNG" width=850>

## Ubuntu End User (VMware Setup) 
1. This virtual machine will be using *Ubuntu 22.04 Desktop image*. The ISO can be downloaded from the [Ubuntu website](https://releases.ubuntu.com/jammy/)

   <img src="Images/D5.PNG" width=750>

2. Once installation is complete you can create a new virtual machine on VMware by selecting *Player* and then *New Virtual Machine*

   <img src="Images/A1.PNG" width=750>

3. Choose *Installer disc image file (iso)* and find path of *Ubuntu Desktop* ISO

   <img src="Images/D1.PNG" width=750>

4. Create username, full name and password

   <img src="Images/D2.PNG" width=750>

5. Name VM to End-User, and pick a file location that has room for 20GB

   <img src="Images/D3.PNG" width=750>

6. Make sure its at least 20GB's for the maximum disk size

   <img src="Images/D4.PNG" width=750>

7. Select Finish and boot up the machine

## Ubuntu End User (Ubuntu Configuration)
The end user machine will simulate a computer at the Cyber-Range. Pam_oauth2 will be used in order to redirect the user login requests to Keycloak (which will check AD). 

1. Installing dependencies

   * Update package repo
     ```sh
     sudo apt update
     ```
   * Install Dependencies
     ```sh
     sudo apt install build-essential libcurl4-openssl-dev libjson-c-dev libssl-dev 
     ```
     ```sh
     sudo apt-get install libpam0g-dev
     ```
   * Install Git 
     ```sh
     sudo apt install git
     ```
     
2. Installing pam_oauth2

   * Use the git clone command
     ```sh
     git clone https://github.com/CyberDem0n/pam-oauth2
     ```

   * As the jsmn file doesnt copy over you will have to use the git clone repo command (replace empty file with this      one)
     ```sh
     git clone https://github.com/zserge/jsmn
     ```
   * Navigate to the pam_oauth2 directory and build it
     ```sh
     cd pam-oauth2
     ```
     ```sh
     make
     ```
     ```sh
     sudo make install 
     ```
