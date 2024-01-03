resource "aws_instance" "web" {
  count = 2

  ami           = "ami-052efd3df9dad4825"
  instance_type = "t2.micro"

  iam_instance_profile = aws_iam_instance_profile.web_server_role_instance_profile.name

  # security_groups             = [aws_security_group.web_server_security_group.id]
  vpc_security_group_ids = [aws_security_group.web_server_security_group.id]
  subnet_id                   = data.aws_subnets.example.ids[0]
  associate_public_ip_address = true

  key_name = "ccdc_demo_IaC"

  tags = {
    Name    = "WebServer${count.index}"
    Project = "CCDC"
  }
}


resource "aws_security_group" "web_server_security_group" {
  name        = "web_server_security_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.selected.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.ip.response_body}/32"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "web_server_security_group"
  }
}
