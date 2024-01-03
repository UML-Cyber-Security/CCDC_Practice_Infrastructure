# Set provider
terraform {
  required_providers {
    xenorchestra = {
      source  = "terra-farm/xenorchestra"
      version = "0.23.3"
    }
  }
}

# Configure the XenServer Provider
provider "xenorchestra" {
  url      = "wss://xoa-ccdc.cyber.uml.edu" # Or set XOA_URL environment variable
  insecure = true

  # Set XOA_USER and set XOA_PASSWORD environment variable
  # username = ""
  # password = ""
}
