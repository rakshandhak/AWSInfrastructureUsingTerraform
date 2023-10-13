provider "aws" {
    region = "us-east-1"
  
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "Project VPC"
  }
}

resource "aws_subnet" "public_subnet_1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet_1a"
  }
}

resource "aws_subnet" "private_subnet_1a" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet_1a"
  }
}

resource "aws_subnet" "public_subnet_1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true
    tags = {
      Name = "public_subnet_1b"
    }
}

resource "aws_subnet" "private_subnet_1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = false
    tags = {
      Name = "private_subnet_1b"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id
    tags = {
      Name = "Project VPC IG"
    }
}

resource "aws_route_table" "second_rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    tags = {
      Name = "2nd Route Table"
    }
}

resource "aws_route_table_association" "public_subnet_1a_asso" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.second_rt.id
}

resource "aws_route_table_association" "public_subnet_1b_asso" {
  subnet_id      = aws_subnet.public_subnet_1b.id
  route_table_id = aws_route_table.second_rt.id
}

resource "aws_instance" "EC2Instance" {
    ami = "ami-053b0d53c279acc90"
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnet_1a.id
    tags = {
      Name = "EC2Instance01"
    }
  
}

