terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

# Create a key pair for SSH access
resource "aws_key_pair" "ec2_key" {
  key_name   = "galoy-key"
  public_key = file("../Keys/pranav-try.pub")
}

# Create security group
resource "aws_security_group" "ec2_sg" {
  name        = "galoy-ec2-sg"
  description = "Allow SSH and HTTP traffic"

  ingress {
    from_port   = 22
    to_port     = 22
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

# EC2 Instance with enhancements
resource "aws_instance" "app_server" {
  ami                    = "ami-0e35ddab05955cf57"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = aws_key_pair.ec2_key.key_name

  tags = {
    Name    = "Galoy-idea3-p1"
    Project = "CompetencyTest"
    Owner   = "YourName"
  }
}

# OUTPUTS
output "public_ip" {
  description = "Public IP of EC2"
  value       = aws_instance.app_server.public_ip
}

output "public_dns" {
  description = "Public IPv4 DNS (for SSH)"
  value       = aws_instance.app_server.public_dns
}

output "region" {
  description = "AWS region used"
  value       = var.region
}

output "instance_type" {
  description = "EC2 instance type (model)"
  value       = aws_instance.app_server.instance_type
}
