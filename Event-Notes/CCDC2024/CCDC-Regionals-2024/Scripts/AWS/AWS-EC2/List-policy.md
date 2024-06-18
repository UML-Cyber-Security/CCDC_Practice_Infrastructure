# EC2

```sh
#/bin/bash

# get regions
readarray -t regions < <(aws ec2 describe-regions --output json | jq -r '.Regions[].RegionName')

# Consant to define a valid region
validregion="us-east-2"
# Loop Through All Regions
for reg in ${regions[@]}; do

    echo "------------------Listing all EC2 instances in the region $reg----------------------"
    # For all the EC2 instances in the region get their IDs
    readarray -t ec2 < <(aws ec2 describe-instances --region $reg --query "Reservations[].Instances[].InstanceId" --output text --no-cli-pager)

    # Just some basic check, maybe some action can be taken if the instance is not in a valid region (shutdown?)
    if [ ${#ec2[@]} -eq 0 ]; then
        continue
    fi

    for instance in ${ec2[@]}; do
        # Done, could be done smarter.
        if [ "$reg" != "$validregion" ]; then
            echo "DANGER ZONE THESE SHOULD NOT BE HERE SHUTTING DOWN"
            aws ec2 stop-instances --no-cli-pager --output json --instance-ids $instance > /dev/null
            continue
        fi

        echo $instance
        # Get the policies attached to an EC2 instance This should be saved in a variable (array?)
        echo "$(aws ec2 describe-instances --instance-ids $instance --query "Reservations[].Instances[].IamInstanceProfile.Arn" --output text)"
        ## I Do not have the setup to test this atm. So I will be lazy and defer
        # We should then print them out

        # Then take some action

    done
done
```

This program will list all EC2 instances in all regions. The goal is also to print out any policies attached to the EC2 instance. Additionally it shuts down any EC2 instances not within a specified region.