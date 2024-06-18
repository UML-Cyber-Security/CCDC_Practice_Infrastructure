data "aws_vpc" "selected" {
  default = true
}

data "aws_subnets" "example" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}


data "http" "ip" {
  url = "https://ifconfig.me"
}
