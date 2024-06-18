#!/bin/sh

ftp -n ftpserver << EOT
user innocentdev 1qazxsW@1
put /home/innocentdev/ICNH.app /home/public/ICNH.app 
quit
EOT
