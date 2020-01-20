# Removed the creation of network and subnets to allow more flexibility

/*
 * ------------GCP STEP 3------------
 * ----CREATE THE HA VPN GATEWAY-----
 */
resource "google_compute_ha_vpn_gateway" "ha-vpn-gw-a" {
  provider = google-beta

  name    = "${data.google_compute_network.gcp-network.name}-to-${data.aws_vpc.aws-vpc.id}-ha-vpn-gateway"
  region  = var.gcp_region
  network = data.google_compute_network.gcp-network.self_link
}

/*
 * ------------GCP STEP 4------------
 * --------CREATE CLOUD ROUTER-------
 */
resource "google_compute_router" "gcp-router" {
  name    = "${data.google_compute_network.gcp-network.name}-to-${data.aws_vpc.aws-vpc.id}-router"
  region  = var.gcp_region
  network = data.google_compute_network.gcp-network.name

  bgp {
    asn = aws_customer_gateway.aws-cgw-one.bgp_asn
  }
}

/*
 * -------GO TO AWS PART ONE-------
 */
