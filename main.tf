terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

#AWS Provider
provider "aws" {
  region = "us-east-1"
}

#EC2 Instance
resource "aws_instance" "jenkins_server" {
  ami             = "ami-053b0d53c279acc90"
  instance_type   = "t2.micro"
  security_groups = ["jenkins_security"]
  key_name        = "Jenkins"

  user_data = file("script.sh")

  tags = {
    Name = "Jenkins-server"
  }
}

#Security Group
resource "aws_security_group" "jenkins_security" {
  name        = "jenkins_security"
  description = "Allows SSH and HTTP traffic"
  vpc_id      = "vpc-052b29e1837e7399e"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["172.58.166.67/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
      Name = "jenkins-security"
  }
}

#S3 Bucket
resource "aws_s3_bucket" "jenkins_artifacts_bucket-tmachek98" {
  bucket = "jenkins-artifacts-bucket-tmachek98"
}

