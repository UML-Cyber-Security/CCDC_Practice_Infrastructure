# Infrastructure as Code

Author: Andrew A

Date: 2022 Aug 22

## What

Infrastructure as Code (IaC) is the managing and provisioning of infrastructure through code instead of through manual processes.
Configuration files are created that contain your infrastructure specifications, which makes it easier to edit and distribute configurations.
It also ensures that you provision the same environment every time. By codifying and documenting your configuration specifications, IaC aids configuration management and helps you to avoid undocumented, ad-hoc configuration changes.

## Why IaC

Video [Infrastructure as Code: What Is It? Why Is It Important?](https://www.hashicorp.com/resources/what-is-infrastructure-as-code)

## Declarative vs. imperative approaches to IaC

- A declarative approach defines the desired state of the system, including what resources you need and any properties they should have, and an IaC tool will configure it for you.

- An imperative approach instead defines the specific commands needed to achieve the desired configuration, and those commands then need to be executed in the correct order.

## What Will be Covered

- [Terraform](./Terraform/README.md)
- [Ansible](./Ansible/README.md)

## Source

- [Terraform](https://learn.hashicorp.com/)
- [RedHat](https://www.redhat.com/en/topics/automation/what-is-infrastructure-as-code-iac)
