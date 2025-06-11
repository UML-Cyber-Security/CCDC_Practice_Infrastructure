variable "public_subnet_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type        = string
  description = "Private subnet CIDR values for proxy and gateway"
  default     = "10.0.2.0/24"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "pub_key_pair" {
  type = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl6EmEzInqOZZgXfBPx6ueKTQ+IkUdjV9rcrNzb/UYwyW3xYWku4HUx9MF/+LvNk2+OFBaXJuSzGlKGOn5RWbM40j6TIrF7EjjIVZbIDHybCKuGKULRnkr2ecNwQ70eCvuK2QYWXDkmBB+UlZ8AGzuDCTtZtrmDNdVDMepqiIkNVNVhGye/1RCmT6o0cb3zAB64TjQ9AC5D281OLv+Wg+xT3anMaL01cRg40G6yCafZubRz1but5U+/Ymq4CYsKho6bqJa7PJeCdT8Mz/EFO7eBRteYeI3PyTsN+rGWj04L7fv5vZO8MbfIY9+KXeU10wW7uvx+u/LCOx+WfXATVh62agBtnVAo8+XNE/J5gAz4l6DQuL+k7esFHSnnYzNcYQQrKyzd8n/trbTdonMiyFkkSlJMOTlDqbzKb1wPNy53z/UH7cDP2fP7tngabp+uVKDF1zMKlfMn6XkcTHkSJu+D7jkpRxinRGvAIpjEqFzo5Iqr51c3Jg8osAhdMBdUEk= omnil@DESKTOP-HJ31GBB"
}

variable "pub_key_name" {
  type = string
  default = "chisom-key"
}