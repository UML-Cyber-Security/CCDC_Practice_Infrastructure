variable "vpc_cidr_block" {
    description = "cidr block for vpc"
    type =  string
    default = "10.0.0.0/16"
}

variable "pub_sub_cidr" {
    description = "cidr block for pub subnet"
    type = string
    default = "10.0.1.0/8"
}

variable "priv_sub_cidr" {
    description = "cidr block for pub subnet"
    type = string
    default = "10.0.2.0/8"
}

