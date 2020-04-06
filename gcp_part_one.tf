# Removed the creation of network and subnets to allow more flexibility

/*
 * ------------GCP STEP 3------------
 * ----CREATE THE HA VPN GATEWAY-----
 */
resource "google_compute_ha_vpn_gateway" "ha-vpn-gw-a" {
  provider = google-beta

  name    = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-ha-vpn-gateway"
  region  = var.gcp_region
  network = var.gcp_network_name
}

/*
 * ------------GCP STEP 4------------
 * --------CREATE CLOUD ROUTER-------
 */
resource "google_compute_router" "gcp-router" {
  name    = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router"
  region  = var.gcp_region
  network = var.gcp_network_name

  bgp {
    dynamic "advertised_ip_ranges" {
      for_each = var.gcp_cidrs
      content {
        range = advertised_ip_ranges.value["cidr"]
        description = advertised_ip_ranges.value["description"]
      }
    }
    asn = var.gcp_side_asn
    advertise_mode    = "CUSTOM"
    advertised_groups = ["ALL_SUBNETS"]
  }
}

/*
 * -------GO TO AWS PART ONE-------
 */
