# DNS 
This documentation will give an overview of the Windows DNS on Server Manager that is installed on Windows 2019. Giving insight on how to download, use, secure, and briefly integrate with Active Directory.

## Info
DNS stands for Domain Name Service and its purpose is to store records that translate domain names into IP addresses. This makes it so it is easier to interact with IPs as it is easier to write down or remeber a domain name rather than a bunch of numbers. For example, when a user enters a domain name into their browser, the user's device sends a request to its DNS server and the DNS server processes that requests and routes the user to the respective IP address. DNS is used in places like email, video chat, apps, IoT, and more. The main way CCDC uses DNS is to hold use domain names to better and more easily use servers and things that require IP adressses, such as pinging or accessing. 

## Install
To start make sure you have server manager open, then go to the top right and click on add or remove features and click add. This will bring up another window where you can choose which tools you would like to install, so click next until you get to this page.


![Screenshot 2024-12-26 143048](https://github.com/user-attachments/assets/bb343c50-7c72-4868-9d30-f5038cb23f5c)

In our case here we will only need to install DNS server so just click the box and go next. NOTE: If you know you will be downloading and using AD DS I advise that you download it at the same time as DNS as it makes the integration of the two much more seamless. Follow AD Docs for further information about the install.

Once you click next just keep doing that and use the default options until you reach the install button where you can just click it. DNS is now installed, YAY!


