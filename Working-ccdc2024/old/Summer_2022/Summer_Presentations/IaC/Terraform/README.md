# Terraform

The core Terraform workflow consists of three stages
- Write: You define resources, which may be across multiple cloud providers and services. For example, you might create a configuration to deploy an application on virtual machines in a Virtual Private Cloud (VPC) network with security groups and a load balancer.
- Plan: Terraform creates an execution plan describing the infrastructure it will create, update, or destroy based on the existing infrastructure and your configuration.
- Apply: On approval, Terraform performs the proposed operations in the correct order, respecting any resource dependencies. For example, if you update the properties of a VPC and change the number of virtual machines in that VPC, Terraform will recreate the VPC before scaling the virtual machines.


## Why Terraform
- Manage any infrastructure
- Track your infrastructure
- Automate changes
- Standardize configurations
- Collaborate


## Provider
Providers allow Terraform to interact with cloud providers, SaaS providers, and other APIs.

Specify the provider and version
```hcl
terraform {
  required_providers {
    mycloud = {
      source  = "mycorp/mycloud"
      version = "~> 1.0"
    }
  }
}
```

![Terraform Provider](https://content.hashicorp.com/api/assets?product=terraform&version=refs%2Fheads%2Fv1.2&asset=website%2Fimg%2Fdocs%2Fintro-terraform-apis.png)

Some providers require you to configure them with endpoint URLs, cloud regions, or other settings before Terraform can use them.

```hcl
provider "aws" {
  region = "us-east-1"
}
```

[Doc](https://www.terraform.io/language/providers/configuration)


## State
Terraform must store state about your managed infrastructure and configuration
Used to map Terraform configuration file resources into external resources (server, files, etc.)

The state can be **local** or **remove** (S3, Azure Blob, Terraform Cloud, etc.)

### Adding to State
- New objects in the configuration files will be automatically added
- Manually import with the command `terraform import <resource> <other info>`

### Remove from State
```bash
terraform state rm <resource>.<name>
```

[Doc](https://www.terraform.io/language/state)


## Resources

Create a local file in the filesystem
```hcl
resource "local_file" "foo" {
    content  = "foo!"
    filename = "~/foo.bar"
}
```

Create a remote resource
```hcl
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```
resources output data associated with them.
One of the attributes that `aws_vpc`  has is the **id** of the created VPC. It would be referenced like `aws_vpc.example.id` 


### Data
Query to get information about a resource

```hcl
data "aws_secretsmanager_secret_version" "by-version-stage" {
  secret_id     = "MySecretInAWS"
  version_stage = "example"
}
```

You would be able to retrieve sensitive data without having it hardcoded into the configuration.

### Input Variables
Can be specified when applying or from a module.
```hcl
variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}
```

#### Usage
```hcl
data "aws_secretsmanager_secret_version" "secret_data" {
  secret_id = var.availability_zone_names
}
```

### Output Variables
Used to return data from a module or from STDOUT
```hcl
output "instance_ip_addr" {
  value = "foobar"
}
```


## CLI
- `terraform init` - Used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

- `terraform validate` - Validates the configuration files in a directory, referring only to the configuration and not accessing any remote services such as remote state, provider APIs, etc.

- `terraform plan` - Creates an execution plan, which lets you preview the changes that Terraform plans to make to your infrastructure.
  - Reads the current state of any already-existing remote objects to make sure that the Terraform state is up-to-date.
  - Compares the current configuration to the prior state and noting any differences.
  - Proposes a set of change actions that should, if applied, make the remote objects match the configuration.

- `terraform apply` - Executes the actions proposed in a Terraform plan.

- `terraform destroy` - Destroy all remote objects managed by Terraform.

- `terraform fmt` - Formats the code.

- `terraform state list` - Lists all resources managed by the state file.

[Doc](https://www.terraform.io/cli/commands)


## Module Basics
Modules help you organize and re-use Terraform configuration.

```hcl
module "vpc" {
  source = "app.terraform.io/example_corp/vpc/aws"
  version = "0.9.3"
}
```

Other values can be specified to a module depending on what **input variables** are used by the module.

The module uses **output variables** to allow use of data from the module itself.

[Doc](https://learn.hashicorp.com/collections/terraform/modules)


## Learning & Additional Resources
- [Terraform Documentation](https://www.terraform.io/docs)
- [Study Guide - Terraform Associate Certification](https://learn.hashicorp.com/tutorials/terraform/associate-study?in=terraform/certification)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
