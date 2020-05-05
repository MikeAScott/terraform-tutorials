variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "key_pair_name" {}

provider "aws" {
    region = "eu-west-1"
    access_key = var.aws_access_key_id
    secret_key = var.aws_secret_access_key
}

resource "aws_instance" "tomcat" {
    ami = "ami-06ce3edf0cff21f07"
    instance_type = "t2.micro"
    key_name = var.key_pair_name
    tags = {
        Name = "ms-web-test"
        Terraform = "true"
        Creator = "Mike"
    }
}