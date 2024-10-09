resource "aws_db_instance" "default" {
  allocated_storage    = 20
  storage_type         = "standard"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  db_name                 = "insecure"
  username             = "validpublic"
  password             = "SecretPassw0rd"
  parameter_group_name = "default.mysql5.7"
  publicly_accessible = true
  db_subnet_group_name = "${aws_db_subnet_group.tfgoof_subnet_group.id}"
  skip_final_snapshot = true
}

resource "aws_db_subnet_group" "tfgoof_subnet_group" {
  name       = "dbsubnetgroup"
  subnet_ids = [aws_subnet.external_db.id, aws_subnet.internal_db.id]

  tags = {
    Owner = var.owner
  }
}


resource "aws_vpc" "tfgoofdbvpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
tags = {
    # Owner = var.owner
  }
}

resource "aws_subnet" "external_db" {
  vpc_id                  = aws_vpc.tfgoofdbvpc.id
  cidr_block = "10.0.20.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Owner = var.owner
  }

}

resource "aws_subnet" "internal_db" {
  vpc_id                  = aws_vpc.tfgoofdbvpc.id
  cidr_block = "10.0.10.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Owner = var.owner
  }

}

# Build Internet Gateway
resource "aws_internet_gateway" "tfgoof_db_gateway" {
  vpc_id = aws_vpc.tfgoofdbvpc.id
  tags = {
    Owner = var.owner
  }
}


#Create a Route Table
resource "aws_route_table" "tfgoof_db_route_table" {
  vpc_id = aws_vpc.tfgoofdbvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tfgoof_db_gateway.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.tfgoof_db_gateway.id
  }
  tags = {
    Owner = var.owner
  }

  }

#Associate Route Table to Subnet
resource "aws_route_table_association" "tfgoof_db_route_association" {
    subnet_id = aws_subnet.external_db.id
    route_table_id = aws_route_table.tfgoof_db_route_table.id
}