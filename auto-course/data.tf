data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["multi-db-vpc"]
  }
}

data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["multi-db-subnet-public-0"] # Picking the first public subnet
  }
  vpc_id = data.aws_vpc.selected.id
}

data "aws_security_group" "db_sg" {
  filter {
    name   = "tag:Name"
    values = ["multi-db-rds-sg"]
  }
  vpc_id = data.aws_vpc.selected.id
}

data "terraform_remote_state" "multi_db" {
  backend = "local"

  config = {
    path = "${path.module}/../multi-db/terraform.tfstate"
  }
}

data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}
