data "google_compute_network" "gcp-network" {
  name = var.gcp_network_name
}

data "aws_ec2_transit_gateway" "aws-transit-gateway" {
  id = var.aws_transit_gateway_id
}
