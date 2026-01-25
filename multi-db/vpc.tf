resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "multi-db-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "multi-db-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "multi-db-subnet-public-${count.index}"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "multi-db-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_db_subnet_group" "default" {
  name       = "multi-db-subnet-group"
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "My DB subnet group"
  }
}

# resource "aws_security_group" "ec2_sg" {
#   name        = "multi-db-ec2-sg"
#   description = "Allow SSH inbound traffic"
#   vpc_id      = aws_vpc.main.id

#   ingress {
#     description = "SSH from anywhere"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "multi-db-ec2-sg"
#   }
# }


resource "aws_security_group" "db_sg" {
  name        = "multi-db-rds-sg"
  description = "Allow inbound traffic on DB port from EC2"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from my IP"
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    cidr_blocks     = [var.my_ip]
  }

  tags = {
    Name = "multi-db-rds-sg"
  }
}
