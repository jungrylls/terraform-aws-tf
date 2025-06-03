// Create VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tecace-vpc"
  }
}

// Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = "ca-central-1${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true

  tags = {
    Name = "tecace-public-subnet-${count.index + 1}"
  }
}

// Private Subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = "ca-central-1${element(["a", "b"], count.index)}"

  tags = {
    Name = "tecace-private-subnet-${count.index + 1}"
  }
}

// Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "tecace-igw"
  }
}

// Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
 tags = {
    Name = "tecace-nat-eip"
  }
}

// NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "tecace-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw]
}

// Route Table for Public Subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tecace-public-rt"
  }
}

// Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "tecace-private-rt"
  }
}

// Associate Public Subnets to Route Table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

// Associate Private Subnets to Private Route Table
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}