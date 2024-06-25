#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

suid_exec=(`find / -type f -perm /4000`)

echo -e "--------------------------------------------------------------\nThe following files have the SUID bit set\n--------------------------------------------------------------"

for file in "${suid_exec[@]}"; do
        echo -e "--------------File Owner-----------------"
        ls -l $file
        echo -e "-----------------------------------------\n\n"

        echo -e "--------------File Running?--------------"
        ps -auxf | grep -v grep | grep $file -A 4 -B 4
        echo -e "-----------------------------------------\n\n"

        echo -e "Would you like to delete, move or ignore the program: $file?\nd for deletion, m for moving and anything else for ignore"
        read responce

        responce=$(echo "${responce:0:1}" | tr '[:upper:]' '[:lower:]')

        if [[ "$responce" == "d" ]]; then
               rm -f $file
               echo "Removed file $file"
                echo "Removed file $file" >> file_report.txt
        elif [[ "$responce" == "m" ]]; then
               mv $file ./Untrusted/
               echo "Moved file $file to $(pwd)/Untrusted"
                echo "Moved file $file to $(pwd)/Untrusted" >> file_report.txt
        else
               echo "Ignored file $file"
                echo "Ignored file $file" >> file_report.txt
        fi
done