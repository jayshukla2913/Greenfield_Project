resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = "greenfield-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnets[count.index]
}

resource "aws_db_subnet_group" "db_subnet_group" {

  name = "greenfield-db-subnet-group"

  subnet_ids = var.private_subnets

  tags = {
    Name = "greenfield-db-subnet-group"
  }

}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}