# Docker Ansible

Install docker on multiple hosts
Checkout the k8s playbook for jobs that require fault tolerance.

## Update hosts

Change the ip addresses for **docker_hosts**

## Run the playbook

```sh
ansible-playbook playbook.yaml --private-key=PATH -u USER
```



## Source

[Source](https://medium.com/@pierangelo1982/install-docker-with-ansible-d078ad7b0a54)