terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  token      = var.token
}

resource "aws_vpc" "my-vpc-1" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name : "terraform"
  }
}

resource "aws_subnet" "public_subnets-1" {
  vpc_id            = aws_vpc.my-vpc-1.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "${var.region}a"
  tags = {

    Name : "terraform"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc-1.id
}

resource "aws_route_table" "my-route_table" {
  vpc_id = aws_vpc.my-vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-igw.id
  }
}

resource "aws_route_table_association" "route-public-association" {
  subnet_id      = aws_subnet.public_subnets-1.id
  route_table_id = aws_route_table.my-route_table.id
}

resource "aws_instance" "nginx-server" {
  ami                         = "ami-095413544ce52437d"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnets-1.id
  vpc_security_group_ids      = [aws_security_group.sg-public.id]
  associate_public_ip_address = true
  key_name                    = "vockey"
  user_data                   = "${file("user-data.txt")}"
}

resource "aws_security_group" "sg-public" {
  name   = "my_sg1"
  vpc_id = aws_vpc.my-vpc-1.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 80
    to_port = 80
    protocol = "tcp"
  }
  
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 443
    to_port = 443
    protocol = "tcp"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
}

output "public_ip" {
  value = aws_instance.nginx-server.public_ip
}