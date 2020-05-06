variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "key_pair_name" {}
variable "whitelist_ips" {
    type = list(string)
}

provider "aws" {
    region = "eu-west-1"
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "ms-allow_ssh_in"
  description = "Allow SSH inbound"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "Allow SSH from whitelist"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.whitelist_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
    Terraform = "true"
    Creator = "Mike"
  }
}

resource "aws_instance" "tomcat" {
    ami = "ami-06ce3edf0cff21f07"
    instance_type = "t2.micro"
    key_name = var.key_pair_name
    security_groups = [ aws_security_group.allow_ssh.name ]
    tags = {
        Name = "ms-web-test"
        Terraform = "true"
        Creator = "Mike"
    }
}

output "public_ip" {
    value = aws_instance.tomcat.public_ip
}

output "public_dns" {
    value= aws_instance.tomcat.public_dns
}