# Self Hosted Access
This assumes (as was done in our case) that the Taiga Instance is hosted on a private network, and requires a **VPN** to access. This document contains the steps required to access the instance, and includes the steps if the certificate of the site is not trusted. 

## Steps
1. Utilize the OpenVPN Certificate you have to access the CyberRange network. A successful connection is shown below. Contact Shashank to get a certificate if you do not have one (update section if Shashank stops giving certificates).
    
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
