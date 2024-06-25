#! /bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

root_id_users_on_system=(`cat /etc/passwd | awk -F: '$3 == 0 && $1 != "root" {print $1}'`)
sh_users=(`grep '/sh$' /etc/passwd | awk -F: '{print $1}'`)
bash_users=(`grep '/bash$' /etc/passwd | awk -F: '{print $1}'`)

echo -e "--------------------------------------------------------------\nThe following users have UID = 0 and are not root\n--------------------------------------------------------------"
for user in "${root_id_users_on_system[@]}"; do
        echo -e "Would you like to delete, lock, change the password of or ignore the user: $user?\nd for delete or l for lock, c for change and anything else for ignore"
        read responce
        responce=$(echo "${responce:0:1}" | tr '[:upper:]' '[:lower:]')

        if [[ "$responce" == "d" ]]; then
               userdel -f $user
               echo -e "Deleted user $user \n\n"
        elif [[ "$responce" == "l" ]]; then
               passwd -l $user
               echo -e "Locked user $user \n\n"
        elif [[ "$responce" == "c" ]]; then
                echo "Please enter a password: "
                read responce
                echo "$user:$responce" | chpasswd
        else
               echo -e "We ignored the user $user\n\n"
        fi
done

echo -e "--------------------------------------------------------------\nThe following users have the /sh shell\n--------------------------------------------------------------"
for user in "${sh_users[@]}"; do
        echo -e "Would you like to delete, lock, change the password of or ignore the user: $user?\nd for delete or l for lock, c for change and anything else for ignore"
        read responce
        responce=$(echo "${responce:0:1}" | tr '[:upper:]' '[:lower:]')

        if [[ "$responce" == "d" ]]; then
                userdel -f $user
                echo -e "Deleted user $user \n\n"
        elif [[ "$responce" == "l" ]]; then
                passwd -l $user
                echo -e "Locked user $user \n\n"
        elif [[ "$responce" == "c" ]]; then
                echo "Please enter a password: "
                read responce
                echo "$user:$responce" | chpasswd
        else
                echo -e "We ignored the user $user\n\n"
        fi
done

echo -e "--------------------------------------------------------------\nThe following users have the /bash shell\n--------------------------------------------------------------"
for user in "${bash_users[@]}"; do
        echo -e "Would you like to delete, lock, change the password of or ignore the user: $user?\nd for delete or l for lock, c for change and anything else for ignore"
        read responce
        responce=$(echo "${responce:0:1}" | tr '[:upper:]' '[:lower:]')

        if [[ "$responce" == "d" ]]; then
                userdel -f $user
                echo -e "Deleted user $user \n\n"
        elif [[ "$responce" == "l" ]]; then
                passwd -l $user
                echo -e "Locked user $user \n\n"
        elif [[ "$responce" == "c" ]]; then
                echo "Please enter a password: "
                read responce
                echo "$user:$responce" | chpasswd
        else
                echo -e "We ignored the user $user\n\n"
        fi
done
