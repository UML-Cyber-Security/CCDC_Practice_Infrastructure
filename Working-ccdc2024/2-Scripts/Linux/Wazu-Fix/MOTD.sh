# Check if the files exist

#######################################################
#Edit the /etc/motd file with the appropriate contents according to your site policy, remove any instances of \m , \r , \s , \v or references to the OS platform OR If the motd is not used, this file can be removed. Run the following command to remove the motd file: # rm /etc/motd
sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/motd
#remove references to the OS platform 

sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/issue
#or references to the OS platform  # They have > in the echo which will bash the contents inside already.
echo "Authorized uses only. All activity may be monitored and reported." >> /etc/issue

sed -i 's#[\/m|\/r|\/s|\/v]##g' /etc/issue.net
#references to the OS platform:
echo "Authorized uses only. All activity may be monitored and reported." >> /etc/issue.net

#### GUI Message
 if [ -f "/etc/gdm3/greeter.dconf-defaults" ]; then 
    echo "[org/gnome/login-screen], banner-message-enable=true, banner-message-text='Authorized uses only. All activity may be monitored and reported.'" >> /etc/gdm3/greeter.dconf-defaults
