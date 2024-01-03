## AWS CLI
In case we don't have access to the management console, we know how to use the CLI.
For windows, go to the following link and download using the installer link in the top right:
https://aws.amazon.com/cli/

For Linux, make sure you have python 2.6.5 or higher and install using pip:
`pip install awscli`

## Configuring the CLI with your credentials

If we are already given an EC2 instance(like in quals), we can retrieve credentials from EC2 instance 
metadata:
https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-metadata.html

Otherwise, run: `aws configure`

AWS Access Key ID [None]: AKIAIOSFODNN7EXAMPLE

AWS Secret Access Key [None]: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY

Default region name [None]: us-east-1

Default output format [None]: json

The AWS Access Key ID and AWS Secret Access Key are your AWS credentials. 

#Todo add info on creating IAM user/roles to get Access Keys, not sure if this is necessary or if we'll even have permission to do this in regionals. Looking into this.

The AWS CLI stores the credentials that you specify with aws configure in a local file named credentials, in a folder named .aws in your home directory.

## Connecting to an EC2 instance through command line
You will need a .pem file that contains the key for the EC2 instance. This key is usually generated when you create the instance. It is only generated once, so if the key is lost, access will also be lost.

Type the following command to ssh into the instance.
(Public DNS) To connect using your instance's public DNS, enter the following command.
ssh -i /path/my-key-pair.pem ec2-user@ec2-198-51-100-1.compute-1.amazonaws.com

Note:
One thing I've seen done is copying this folder to a docker container, and automating deployment of AWS services using docker.
