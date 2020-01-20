data "google_compute_network" "gcp-network" {
  name = var.gcp_network_name
}

data "aws_vpc" "aws-vpc" {
  id = var.aws_vpc_id
}
