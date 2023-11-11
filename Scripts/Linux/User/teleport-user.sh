users=(`tctl users ls 2> /dev/null | awk -F ' ' '{print $1}'`)
found=0

for user in "${users[@]:2}"; do
        if [[ $user == "ccdc-blue-team" ]]; then
                echo "Found Our Users"
                found=1
        else
                tctl users rm $user
        fi

done

if (( $found == 0 )); then
        echo "Creating our user"
        tctl users add ccdc-blue-team --roles=access,editor --logins=admin,user,root,cccd-blue
fi