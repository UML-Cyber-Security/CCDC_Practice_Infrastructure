## CCDC Infrastructure as Code Setup ##

### Install Intructions ## 

To install Terraform on Debian-based systems, do the following. Updated intructions can be found on the Hashicorp website: https://learn.hashicorp.com/tutorials/terraform/install-cli. 


``` 
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list```

sudo apt update; sudo apt install terraform -y
```

Installing Terraform on Windows is as simple as: 

```choco install terraform -y``` 


### XOA & Terraform Integration Setuo ### 

https://registry.terraform.io/providers/terra-farm/xenorchestra/latest/docs 

### General Guide ###

https://xen-orchestra.com/blog/virtops1-xen-orchestra-terraform-provider/