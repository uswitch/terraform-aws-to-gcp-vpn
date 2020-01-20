data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = [var.aws_subnet_name]
  }
}

data "aws_route_table" "selected" {
  subnet_id = data.aws_subnet.selected.id

  filter {
    name   = "tag:Name"
    values = [var.aws_route_table_name]
  }
}

data "aws_vpc" "aws-vpc" {
  filter {
    name   = "tag:Name"
    values = [var.aws_vpc_name]
  }
}