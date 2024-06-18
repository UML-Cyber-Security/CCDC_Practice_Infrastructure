# Apache Docker Installation on Arch

## Installation and setup
- **Run "pacman -Syu docker"** to install docker, update the repos, and update the system
- **Run "sudo systemctl enable docker"**
- **Run "sudo systemctl start docker'**
- **Run "mkdir docker-nginx"**
- **Run "cd docker-nginx"**
- **Run "touch Dockerfile"**
- **Run "touch index.html"**
- **Run "nano index.html"**
- Write the following into the file:
  <!DOCTYPE html>
  <html>
  <body>
  
  <h1>Hello docker</h1>
  
  </body>
  </html>
- ctrl-x, y, enter to save
  
## Configuring the Dockerfile
- **

sudo docker build . -t nginx
