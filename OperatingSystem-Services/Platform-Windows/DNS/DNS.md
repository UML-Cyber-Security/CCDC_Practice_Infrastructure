# DNS 
This documentation will give an overview of the Windows DNS on Server Manager that is installed on Windows 2019. Giving insight on how to download, use, secure, and briefly integrate with Active Directory.

## Info
DNS (Domain Name System) is a system that translates human-readable domain names, such as www.example.com, into machine-readable IP addresses, like 192.0.2.1. This allows users to access websites using easy-to-remember names instead of numerical IP addresses. DNS functions like a phonebook for the internet, ensuring that browsers can locate websites and services based on their domain names.

## Install
To start make sure you have server manager open, then go to the top right and click on add or remove features and click add. This will bring up another window where you can choose which tools you would like to install, so click next until you get to this page.


![Screenshot 2024-12-26 143048](https://github.com/user-attachments/assets/bb343c50-7c72-4868-9d30-f5038cb23f5c)

In our case here we will only need to install DNS server so just click the box and go next. NOTE: If you know you will be downloading and using AD DS I advise that you download it at the same time as DNS as it makes the integration of the two much more seamless. Follow AD Docs for further information about the install.

Once you click next just keep doing that and use the default options until you reach the install button where you can just click it. DNS is now installed, YAY!

## DNS Manager
Once the DNS is installed you can now access the DNS manager, which can be opened via clicking tools in the top right and finding "DNS Manager". With this open we can now create forward and reverse lookup zones, trust points, and conditional forwarders, as well as setting various options such as security or logging preferences by clicking properties on the server.

One of the most basic things that we can do with DNS is create a Forward Lookup Zone where we can map domain names to ip addresses. To do so just right click Forward Lookup Zone folder and click new zone, this will pull up a page like this:

![Screenshot 2024-12-26 143454](https://github.com/user-attachments/assets/0229fe46-0d50-4530-a630-f1bb21d36cbd)

Since this is our only DNS server currently we want a primary zone. After clicking next it will bring us to a new page where we enter in the zone name, the zone name is important because it is a unique name that specifies a specific area of the DNS namespace. In the example we use zodu.com, so whatever Host A record name we put in this zone will look something like example.zodu.com

![Screenshot 2024-12-26 143504](https://github.com/user-attachments/assets/17d7cea1-b3f7-48eb-b012-464b466a91d7)

The next two pages aren't necessarily important unless you need it for a specific reason, so in our case we will just use the defaults and click next until the new Forward Lookup Zone is all set. Once the zone is configured you should fine two important records already in there, one being the State of Authority (SOA) and the other being a Name Server (NS) record. The SOA is an important record that stores information about a domain or zone, which can include when the zone was last updated, how long the server should wait between refreshes, when the zone was created and more. The NS record stores and points to the authoritative name server which in this case is the localhost, but in other situations it could be a different server if you have different DNS. With that you are also able to create your own DNS records, the most common one we will use is an A record which maps a domain name to an ip address. 

To create an A record just right click your new Forward Lookup Zone and click new A record (You will see A or AAAA record, A is for IPv4 addresses and AAAA is for IPv6 addresses), which will bring a page like this up:

![Screenshot 2024-12-26 143716](https://github.com/user-attachments/assets/c7eb1896-2147-4a11-89c5-8630889d597a)

This is fairly simple but all we are doing is just giving an ip address a name, so in the example above we are giving our proxy machine a domain name so all we did is put nginx as the name and give the respective ip address, and once completed just click add host and it should be good. Now we are able to communicate to this machine 192.168.2.250 by using the domain name nginx.zodu.com. 
