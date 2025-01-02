# KeyCloak
Keycloak is an open-source identity and access management (IAM) solution designed to help secure applications by providing centralized authentication and authorization services. It supports various security protocols and can integrate with different types of applications and services, both on-premise and in the cloud.

Official Website: https://www.keycloak.org/

## Getting Started (Docker)
In order to get started we will need to install Docker as this documentation focuses on using the advantages of Docker to better use KeyCloak in general. If you already have Docker installed you can skip to KeyCloak Install.

Below is the squential command lines needed to download and install Docker, more in depth documentation on the workings of Docker should be found elsewhere on this repo.

```sh
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.Docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.Docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install Docker-ce
```
Once you have installed Docker you will be able to run and start it with the following commands
```sh
sudo systemctl start Docker
sudo systemctl enable Docker
```
Then you can verify the Docker installation by running and seeing the version output
```sh
Docker --version
```

## KeyCloak Install
To begin since KeyCloak provides its own Docker image for us we can use that to get KeyCloak up and running. 
```sh
Docker pull quay.io/keycloak/keycloak:latest
```
> Can change :latest to any KeyCloak version you would like if preferred 

Now that we have pulled the latest KeyCloak image all we need to do is to execute a Docker run command that looks like this:
```sh
Docker run -d \
  --name keycloak \
  -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USER=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=erjfnwom \
  quay.io/keycloak/keycloak:latest start-dev
```
After you execute this make sure to run
```sh
sudo Docker ps -a
```
to make sure that the container is running normally

#### Docker Command Breakdown
```sh
Docker run -d \
```
this will run the Docker container in detached mode, which will make it so the container runs in the background
```sh
--name keycloak \
```
this will set the name of the container to keycloak making stopping, restarting, starting, etc. more easy to do
```sh
-p 8080:8080 \
```
this maps port 8080 on the host machine to port 8080 on the container, this is also the default keycloak port
```sh
 -e KC_BOOTSTRAP_ADMIN_USER=admin \
```
-e creates an environment variable, in this case it is setting the bootstrap username to admin. You can make the username whatever you want.
```sh
-e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
```
similar to above, this environment variable is setting the password of the bootstrap account, in this case the password is admin
```sh
 quay.io/keycloak/keycloak:latest start-dev
```
this references the keycloak image and starts keycloak in dev mode

After running this Docker run command and verifying that the container is up and running, enter the following into your browser to pull up the sign-in page for KeyCloak.
```sh
http://localhost:8080
```

Once you have entered the url above into your browser it should bring you to a page like this. be aware, it may take a few minutes for it to load, if you dont see it immediately after the container is setup.

![image](https://github.com/user-attachments/assets/10dc2409-72e4-475d-933e-9e11c1db8581)



And after signing in you should be able to see the homepage:

![image](https://github.com/user-attachments/assets/674a9b21-f7e6-47a5-a2ff-e489bb54e583)




## KeyCloak Install Troubleshooting
There were two main issues I ran into when first setting up KeyCloak with Docker. One of them being the environment variables related to the username and password. It is important that they are named like they are above, otherwise KeyCloak doesn't neccesarilly recognize them and you will be unable to sign in. The other issue I ran into was the Docker container exiting shortly after it was started. It gave me two different types of exit codes after running Docker ps -a. Exit(0) which means the container completed its task succesfully and shut off afterwards, this may be a problem in your initialization such as not running the container with -d. The other code I got was exit(2) which means the process running on the container, in this case KeyCloak, ran into an issue and exited. Again this is most likely because the intitialization was wrong or incomplete, so double check it.

Watch out if your machine is behind a proxy you might have to configure Docker to use the proxy as well.
```sh
sudo nano /etc/systemd/system/Docker.service.d/http-proxy.conf
```
Then within this new folder
```sh
[Service]
Environment="HTTP_PROXY=http://your-proxy-address:port"
Environment="HTTPS_PROXY=http://your-proxy-address:port"
#Environment="NO_PROXY=localhost,127.0.0.1,.Docker.io,.quay.io"
```
```sh
sudo systemctl daemon-reload
sudo systemctl restart Docker
```

Any other issues can hopefully be solved by looking at the KeyCloak documentation on their website: https://www.keycloak.org/getting-started/getting-started-Docker

## KeyCloak Post-Install





