provider "aws" {
  region = "us-east-1"
}
#creating security group, allow ssh and http
resource "aws_security_group" "hello-ip-ssh-http" {
  name        = "hello-ip-ssh-http-sg"
  description = "restricting traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# Security group ends here

# creating AWS EC2 instance
resource "aws_instance" "hello-ip" {
  ami = "ami-085925f297f89fce1"
  instance_type     = "t2.micro"
  availability_zone = "us-east-1e"
  security_groups   = ["${aws_security_group.hello-ip-ssh-http.name}"]
  key_name          = "aws_connect_key"
  user_data         = <<-EOF
        #!/bin/sh
        sudo apt-get update
        sudo apt-get install -y apache2
        sudo service start apache2
        sudo chkonfig apache2 on
        ip_address=`hostname -I | awk '{print $1}' | tr -d "\n"`
        echo "<h1>Hello from $ip_address !!" > /var/www/html/index.html
    EOF
  tags = {
    Name = "hello_ip_instance"
  }
}
