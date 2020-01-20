/*
 * ------------GCP STEP 1------------
 * ---CREATE A CUSTOM VPC NETWORK----
 */
resource "google_compute_network" "gcp-network" {
  name                    = "gcp-network"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = "false"
}

/*
 * ------------GCP STEP 2------------
 * ----------CREATE SUBNETS----------
 */
resource "google_compute_subnetwork" "gcp-subnet1" {
  name          = "gcp-subnet1"
  network       = google_compute_network.gcp-network.name
  region        = var.gcp_region
  ip_cidr_range = var.gcp_subnet1_cidr
}

resource "google_compute_subnetwork" "gcp-subnet2" {
  name          = "gcp-subnet2"
  network       = google_compute_network.gcp-network.name
  region        = var.gcp_region
  ip_cidr_range = var.gcp_subnet2_cidr
}


module "aws-to-gcp-vpn" {
  source = "./module"

  # AWS Variables
  aws_vpc_id = data.aws_vpc.aws-vpc.id
  aws_region = var.aws_region
  bgp_asn    = var.bgp_asn

  # GCP Variables
  gcp_network_name = google_compute_network.gcp-network.name
  gcp_subnet1_cidr = var.gcp_subnet1_cidr
  gcp_subnet2_cidr = var.gcp_subnet2_cidr
  gcp_region       = var.gcp_region

}

# ADDITIONAL STEP. ADD ROUTE TO VPN GATEWAY
resource "aws_route" "route_to_vpn_gateway" {
  route_table_id         = data.aws_route_table.selected.id
  destination_cidr_block = google_compute_subnetwork.gcp-subnet1.ip_cidr_range
  gateway_id             = module.aws-to-gcp-vpn.aws_vpn_gateway_id
}
