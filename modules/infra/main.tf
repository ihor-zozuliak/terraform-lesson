resource "aws_vpc" "avenga-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns
  enable_dns_hostnames = var.enable_dns
}
resource "aws_subnet" "avenga-subnet" {
  vpc_id                  = aws_vpc.avenga-vpc.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.az
  map_public_ip_on_launch = true
  tags = {
    Name = "Main"
  }
}
resource "aws_internet_gateway" "avenga-igw" {
  vpc_id = aws_vpc.avenga-vpc.id
  tags = {
    Name = "main"
  }
}
resource "aws_route_table" "avenga-rt" {
  vpc_id = aws_vpc.avenga-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.avenga-igw.id
  }
  tags = {
    Name = "example"
  }
}
resource "aws_route_table_association" "avenga-rt-assoc" {
  subnet_id      = aws_subnet.avenga-subnet.id
  route_table_id = aws_route_table.avenga-rt.id
}
