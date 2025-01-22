# Table of Contents  <!-- omit from toc -->
- [About](#about)
- [Workflow](#workflow)
  - [Install Terraform on linux](#install-terraform-on-linux)
  - [Configure the Terraform provider](#configure-the-terraform-provider)
  - [Write configuration files](#write-configuration-files)
  - [Initialize Terraform](#initialize-terraform)
  - [Run terraform plan](#run-terraform-plan)
  - [Create resources with terraform apply](#create-resources-with-terraform-apply)
  - [Delete resources using terraform destroy](#delete-resources-using-terraform-destroy)
- [Notes:](#notes)

# About
This file describes the general flow I use for starting and creating a aws-based teraform  infrastructure

Author: Chisom Ukaegbu

# Workflow
## Install Terraform on linux
1. Install Terraform (ubuntu debian ver.)
   
   - ` wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings  hashicorp-archive-keyring.gpg`
   
    - `echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list`

    - `sudo apt update && sudo apt install terraform `



## Configure the Terraform provider
For our example we will focus on using aws as the cloud provider aka the place where out machines will be created & hosted

AWS will be our cloud provider and set up an account on aws cloud provider 

0. You will need AWS Access KEY ID & AWS Secret Key ID
    This is gathered from the aws web console. Create a user or use a preexisting user. 

    ![aws-create-user.png](/images/aws-create-user.png)
    

    Grab there access and secret key ids.

    ![alt text](/imageS/aws-secret-key.png)

1. Run `Aws Configure` in your terminal.
   Input your keys
```sh
blueteam@cyber-range tf-tuts % aws configure
AWS Access Key ID [****************PYVK]: ****PYVK
AWS Secret Access Key [****************duMt]: ****duMt
Default region name [eu-central-1]: <same region where you want to place the machines> 
Default output format [None]: 
blueteam@cyber-range tf-tuts %
```

## Write configuration files
1. Setup Cloud Provider

   Convention says to place this config in a file name provider.tf. It does not matter aslong as the file has the .tf extension and is unique in name.

```yaml
    terraform {
    required_providers {
        aws = {
            source = hashicorp/aws
            version = " ~> 4.19.0" 
           }
        } 
    }
```
2. Create instances
   
    Create a main.tf file. Convention is to name the file "main.tf"

    This is where the block of the cofiguration for the virtual machines will be deployed
   
```yaml
# creating the code to create an EC2 instance in AWS using Terraform.
resource "aws_instance" "my_vm" {

 ami                       = "ami-065deacbcaac64cf2" //Ubuntu AMI
 instance_type             = "t2.micro"
  
 tags = {
   Name = "My EC2 instance",
 }

###########
# declared a resource block of type “aws_instance”.
### This instructs Terraform that we want to create an EC2 instance resource in AWS with the given attributes

# second parameter is “`my_vm`”, an internal identifier that refers to this ##particular EC2 instance elsewhere in the code. We can assign any name to this identifier


# assigned a `tag` “Name” with the value “My EC2 Instance”.
```

## Initialize Terraform 
1. Intialize terraform

    Run this command in your terminal of the same directory your provider is.
    ```sh
    terraform init
    ```
    You should see these hidden files. when running 
    ```sh
    ls -l
    .  ..  .terraform  .terraform.lock.hcl  provider.tf
    ```

2. Format the code
    This command will auto fixed syntax and indentation of your configuration code
    ```sh
    terraform fmt
    ```


## Run terraform plan
    This command will output 2 scenarios
        output: identify and highlight resources that will be created, updated, or deleted if we choose to execute the current version of the code
        
        or

        Show issues regarding your terraform file

    ```sh
    terraform plan`
    ```
    ![t-fmt-1](</images/t-fmt-1.png>)
    ![t-fmt-2](</images/t-fmt-2.png>)



## Create resources with terraform apply

Running the command `terraform apply` will begin to create
```sh
terraform apply
```

Now if you navigate to aws, you will see the instances created.

Make sure you are in the same region as the provider you selected.

## Delete resources using terraform destroy

```sh
terraform destory
```

Will delete any resources provisioned by your terraform script.
Virtual machines, vpcs, subnets etc are considered resources


# Notes: 
There is more you can do with terraform but this is a quick start guide for creating an instance or network for the first time.