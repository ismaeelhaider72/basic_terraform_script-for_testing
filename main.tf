terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.74.0"
    }
  }
}

provider "aws" {
    region = "us-east-1"
  # Configuration options
}

resource "aws_instance" "my_instance" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.small"
  key_name = "ismaeel_virginia_key"
  vpc_security_group_ids = "allow_ssh_sg"
  subnet_id = "subnet-0d9e6474140c1f6fc"
  associate_public_ip_address = true

  tags = {
    Name = "Ismaeel-jenkins-slave2-instance"
  }
}
