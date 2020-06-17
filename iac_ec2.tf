provider "aws" {
    region = "us-east-1e"
}

#creating security group, allow ssh and http
resource "aws_security_group" "hello-ip-ssh-http" {
    name = "hello-ip-ssh-http"
    description = "restricting traffic"
    
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    egress {  
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
# Security group ends here

# creating AWS EC2 instance
resource "aws_instance" "hello-ip" {
    ami = ""
    instance_type = "t2.micro"
    availability_zone = "us-east-1e"
    security_groups = ["${aws_security_group.hello-ip-ssh-http.name}"]
    key_name = "aws_connect_key"
    user_data = <<-EOF
        #!/bin/bash
        sudo yum install httpd -y
        sudo systemctl start httpd
        sudo systemctl enable httpd
        ip_address=`hostname -I | awk '{print $1}' | tr -d "\n"`
        echo "<h1>Hello from $ip_address !!" >> /var/www/html/index.html/index
    EOF
    tags = {
        Name = "exercise_code"
    }
 }
