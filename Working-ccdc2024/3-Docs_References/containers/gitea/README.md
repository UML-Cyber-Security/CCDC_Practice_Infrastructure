# Setting up Gitea
## Installation 
`docker pull gitea/gitea`
## Set-up guide 
https://docs.gitea.io/en-us/install-with-docker/
## docker-compose file
./docker-compose.yml
## Logging into the web GUI
Go to `http://<ip-address>:<port>`
Use the port that was mapped to port 3000 in the docker-compose.yml
Finalize your SQL preferences and click "Install Gitea"
Wait a few minutes and refresh the browser
Click "register" and make an account

# Using Gitea
Now that you have an account and Gitea is ready for use, you can use it like any other git server.
