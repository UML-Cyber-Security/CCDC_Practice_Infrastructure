#! /bin/bash

# This is just for fun!

# Works for users without a * in the feild originally.

# Generate list of users 
users=$(awk -F: '($3>=1000)&&($1!="nobody"){print $1}' /etc/passwd)
# Add root to that list
users=("root" "${users[@]}")
# Create a temporary storage file 
touch temp_store.txt

# Iterate through all users 
for user in ${users[@]}
do
    while true 
    do
        # First we need to check if the user would like to change the password
        echo -e "Would you like to change the user: $user's passowrd?\nType \"Yes\" or \"No\" this is case insensitive"
        read clientanswer
        # make the answer case insensitve
        clientanswer=$(echo $clientanswer | tr '[:upper:]' '[:lower:]')
        if [ $clientanswer = "yes" ]; then
            # Grab users old password hash (we will use this in sed to replace)
            old=$(grep $user /etc/shadow | awk -F ':' -e '{print $2}')
            echo "The old hash is: $old" # DEBUG
            # generate a random string of alphanumeric charicters (20 long)
            string=$(cat /dev/urandom | base64 | head -c 20)
            # Generate a random salt
            salt=$(cat /dev/urandom | base64 | head -c 16)
            # generate the new password hash to insert in the file
            hash=$(openssl passwd -6 -salt $salt  $string)
            echo "the new hash is $hash" # DEBUG
            echo "for $user:$old"
            # Then we get into the changing of the passwords 
            sed -i "s,$user:$old,$user:$hash,g" /etc/shadow
            echo "$user : $string" >> /temp_store.txt
            break
        elif [ $clientanswer = "no" ]; then
            break
        fi
    done

    

    
done 


# Flush old vsriables 
string=""
salt=""
hash=""
old=""

 echo $string
 echo  $hash