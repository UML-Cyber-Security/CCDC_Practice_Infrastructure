# AWS IAM Access Key

```sh
#!/bin/bash

# Current not using the regions because this is global, AWS IAM CLI gives the region option for the keys
readarray -t regions < <(aws ec2 describe-regions --output json | jq -r '.Regions[].RegionName')

#for region in "${regions[@]}"; do
echo -e "-------------Listing Access Keys for the AWS Account and Username------------\n"
#aws iam list-access-keys --output json --no-cli-pager
#done

readarray -t usernames < <(aws iam list-access-keys --output json --no-cli-pager | jq -r ".AccessKeyMetadata[].UserName")
readarray -t keyID < <(aws iam list-access-keys --output json --no-cli-pager | jq -r ".AccessKeyMetadata[].AccessKeyId")

for ((i = 0; i < ${#usernames[@]}; i++)); do
    echo "User ${usernames[i]} has access key with ID ${keyID[i]}"
    # Danger Zone
    echo -e "Would you like to delete the key?\ny for YES and anyhting else for no"
    read usr
    if [ "$usr" = "y" ]; then
       echo "Hello"
       # aws iam delete-access-key --access-key-id ${keyID[i]}
    fi
done
```

This script is used to list all users with AWS CLI Access Keys.