# KeyCloak
Keycloak is an open-source identity and access management (IAM) solution designed to help secure applications by providing centralized authentication and authorization services. It supports various security protocols and can integrate with different types of applications and services, both on-premise and in the cloud.

## Getting Started
In order to get started we will need to install docker as this documentation focuses on using the advantages of docker to better use KeyCloak in general. If you already have docker installed you can skip to KeyCloak Docker Install

Below is the squential command lines needed to download and install docker, more in depth documentation on the workings of docker should be found elsewhere on this repo.

```sh
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce
```
Once you have installed docker you will be able to run and start it with the following commands
```sh
sudo systemctl start docker
sudo systemctl enable docker
```
Then you can verify the docker installation by running and seeing the version output
```sh
docker --version
```

## KeyCloak Docker Install


