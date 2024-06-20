# AV & RootKit
Installing an Antivirus and a RootKit hunting program is important in most every case as this allows us to with minimal effort catch malware that the Red team may use against our systems to compromise them. If they have installed a root kit there is not much we can do it has been said in that case we are "Fu**ed". 

## AV 
We are using the free Antivirus Solution [ClamAV](https://www.clamav.net/). This can be installed in the following manner. (on a Debian based System)
1. ```apt install clamav clamav-daemon```
   * Use ```clamscan --version``` to verify it is working if you would like 
2. (Optional) ```systemctl stop clamav-freshclam``` && ```freshclam``` && ```systemctl start clamav-freshclam```
   * This refreshes Clam's signatures. You can only do this a limited number of times. So this can be skipped
3. Scan ```clamscan -i -v -r /```
   * Add the flag ```--log=logfile.txt``` to log into a text file. (Can this be pulled with Wazuh?)


## RKHunter
1. ```apt install rkhunter```
   * This has a Human interaction component. This needs to be considered when scripting
   * ```rkhunter --propupd``` can be used to check that the install worked correctly
2. ```rkhunter --check```
   * May be able to use the ```--sk``` flag to skip the user interaction. 
   * May also be able to use the ```yes``` command to skip. 
     * ```yes $'\n' | sudo rkhunter -``` 
