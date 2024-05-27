# Network configuration

# VPC creation
resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-http"
  }
}

# http subnet configuration
resource "aws_subnet" "http" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.vpc_cidr # Now there is a fatal error in code
  tags = {
    Name = "subnet-http"
  }
  depends_on = [aws_internet_gateway.gw]
}

# db subnet configuration
resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.vpc_cidr # Now there is a fatal error in code
  tags = {
    Name = "subnet-db"
  }
  depends_on = [aws_internet_gateway.gw]
}

# External gateway configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    Name = "internet-gateway"
  }
}

