# Infrastructure as Code Demo

Will be two part, covering Terraform to create AWS resources and then Ansible on the provisioned infrastructure.

## Terraform

### Setup State

`settings.tf`
```hcl
terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }
}
```

### Setup Providers

`settings.tf`
```hcl
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "local" {
    path = "./terraform.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.26.0"
    }
  }
}
```

#### Init

```bash
terraform init
```

Look into the state file

### Resources

Show off all the types of resources

- Two EC2 servers
- Data from VPC / Subnet
- Security group
- IAM Policy
- IAM Role & Profile

#### Verify

```bash
terraform fmt
terraform validate
terraform plan
```

### Variables

- Server 1 Tag Name
- Server 2 Tag Name
- Which Subnet

#### .tfvar file

### Output

Output the server Public IPv4 addresses

### Apply

```bash
terraform apply
```


## Ansible

## Create Inventory

```host
SERVER.IP
ALIAS_NAME ansible_host=SERVER.ONE

[GROUP_ONE]
SERVER.IP

[GROUP_TWO]
ALIAS_NAME
```

## Basics of Ansible Structure

- Playbook
- Play
- Task
- Module

### SSH Hardening

- Variables per host

### Web Server

- Loop for software
- Nginx

### File Manipulation

- When, have each server different
- New default page
