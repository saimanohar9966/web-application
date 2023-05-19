resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "webapp-vpc"
  }
}

resource "aws_subnet" "mysubnet1" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "ap-southeast-2a"
  cidr_block        = "10.0.1.0/24"
  tags = {
    Name = "webapp-subnet1"
  }
}

resource "aws_subnet" "mysubnet2" {
  vpc_id            = aws_vpc.myvpc.id
  availability_zone = "ap-southeast-2b"
  cidr_block        = "10.0.2.0/24"
  tags = {
    Name = "webapp-subnet2"
  }
}

resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "webapp-subnet"
  }
}

resource "aws_route_table" "myrt" {
  vpc_id = aws_vpc.myvpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }
  tags = {
    Name = "webapp-routetable"
  }
}

resource "aws_route_table_association" "myrta1" {
  subnet_id      = aws_subnet.mysubnet1.id
  route_table_id = aws_route_table.myrt.id
}

resource "aws_route_table_association" "myrta2" {
  subnet_id      = aws_subnet.mysubnet2.id
  route_table_id = aws_route_table.myrt.id
}

