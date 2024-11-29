provider "aws" {
  region = "eu-west-1" # Replace with your desired region
}

resource "aws_key_pair" "yu-key-pair" {
  key_name   = "yu-key"
  public_key = file("${path.module}/yu-key.pub")
}

resource "aws_vpc" "vpc-test-yu" {
  cidr_block           = "10.0.0.0/16"
  tags = {
    Name = "vpc-test-yu"
  }
}

resource "aws_internet_gateway" "igw-test-yu" {
  vpc_id = aws_vpc.vpc-test-yu.id

  tags = {
    Name = "igw-test-yu"
  }
}

resource "aws_route_table" "test-yu" {
  vpc_id = aws_vpc.vpc-test-yu.id
  tags   = { Name = "demo-rt-public" }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-test-yu.id
  }
}

resource "aws_route_table_association" "public-test-yu" {
  subnet_id      = aws_subnet.public-subnet-test-yu.id
  route_table_id = aws_route_table.test-yu.id
}



resource "aws_subnet" "public-subnet-test-yu" {
  vpc_id            = aws_vpc.vpc-test-yu.id
  cidr_block        = "10.0.1.0/24"

  availability_zone = "eu-west-1a"

  map_public_ip_on_launch = true
}

resource "aws_instance" "ec2-test-yu" {
  ami           = "ami-02141377eee7defb9" 
  instance_type = "t2.micro"

  key_name = aws_key_pair.yu-key-pair.key_name

  subnet_id = aws_subnet.public-subnet-test-yu.id
  security_groups = [aws_security_group.sg-test-yu.id]

  tags = {
    Name = "ec2-test-yu"
    Owner = "yu"
  }

  

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo systemctl start docker
sudo systemctl enable docker   

EOF
}

resource "aws_security_group" "sg-test-yu" {
  name        = "test-yu"
  description = "Allow TLS inbound traffic"

  vpc_id = aws_vpc.vpc-test-yu.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-test-yu"
  }
}
