terraform {
  # We'll be using AWS for our provisions.
  required_providers {
    # Contains this attribute to which an object a couple
    # of properties is assigned.
    # This will instruct Terraform to initialize the AWS provider with version 4.19.0.
    # Initialize the Terraform project, run "terraform init" in the root directory.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.19.0"
    }
  }
}