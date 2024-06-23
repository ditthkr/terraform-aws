resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  for_each = var.cidr_public_subnets

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value
  availability_zone       = "ap-southeast-1${each.key}"
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.vpc_name}-subnet-public-${var.region}${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = var.cidr_private_subnets
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value
  availability_zone = "ap-southeast-1${each.key}"
  tags = {
    Name = "${var.vpc_name}-subnet-private-${var.region}${each.key}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_subnet["a"].id
  tags = {
    Name = "${var.vpc_name}-ngw"
  }
  depends_on = [aws_internet_gateway.igw]
}

## public route table
resource "aws_default_route_table" "public_route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public"
  }
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each = aws_subnet.public_subnet

  subnet_id      = each.value.id
  route_table_id = aws_default_route_table.public_route_table.id
}

## private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
  }
  tags = {
    Name = "${var.vpc_name}-private"
  }
}


resource "aws_route_table_association" "private_route_table_association" {
  for_each = aws_subnet.private_subnet

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}

