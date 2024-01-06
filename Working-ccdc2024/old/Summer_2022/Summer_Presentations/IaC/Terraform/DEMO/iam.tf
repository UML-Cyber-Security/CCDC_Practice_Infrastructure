resource "aws_iam_role" "web_server_role" {
  name                  = "WebServer"
  path                  = "/"
  description           = "Role for web server EC2"
  force_detach_policies = false
  max_session_duration  = 3600

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]

  assume_role_policy = <<-JSON
    {
      "Version": "2008-10-17",
      "Statement": [
        {
          "Sid": "",
          "Effect": "Allow",
          "Principal": {
            "Service": "ec2.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }
  JSON
}


resource "aws_iam_instance_profile" "web_server_role_instance_profile" {
  name = "WebServerProfile"
  role = aws_iam_role.web_server_role.name
}
