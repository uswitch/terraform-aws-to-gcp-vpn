/*
 * ------------GCP STEP 5------------
 * ------CREATE AN EXTERNAL VPN------
 * --------GATEWAY RESOURCE----------
 */
resource "google_compute_external_vpn_gateway" "external_gateway" {
  provider = google-beta

  name            = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-external-vpn-gateway"
  redundancy_type = "FOUR_IPS_REDUNDANCY"
  description     = "An externally managed VPN gateway"
  interface {
    id         = 0
    ip_address = aws_vpn_connection.aws-vpn-connection1.tunnel1_address
  }
  interface {
    id         = 1
    ip_address = aws_vpn_connection.aws-vpn-connection1.tunnel2_address
  }
  interface {
    id         = 2
    ip_address = aws_vpn_connection.aws-vpn-connection2.tunnel1_address
  }
  interface {
    id         = 3
    ip_address = aws_vpn_connection.aws-vpn-connection2.tunnel2_address
  }
}

/*
 * ------------GCP STEP 6------------
 * -------CREATE VPN TUNNELS ON------
 * --------THE HA VPN GATEWAY--------
 */
resource "google_compute_vpn_tunnel" "tunnel-to-aws-connection-0-ip0" {
  provider = google-beta

  name = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-vpn-tunnel-1-ip-1"

  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = google_compute_external_vpn_gateway.external_gateway.interface.0.id
  region                          = var.gcp_region
  ike_version                     = 2
  shared_secret                   = aws_vpn_connection.aws-vpn-connection1.tunnel1_preshared_key
  router                          = google_compute_router.gcp-router.name
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha-vpn-gw-a.self_link
  vpn_gateway_interface           = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.0.id
}

resource "google_compute_vpn_tunnel" "tunnel-to-aws-connection-0-ip1" {
  provider = google-beta

  name = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-vpn-tunnel-1-ip-2"

  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = google_compute_external_vpn_gateway.external_gateway.interface.1.id
  region                          = var.gcp_region
  ike_version                     = 2
  shared_secret                   = aws_vpn_connection.aws-vpn-connection1.tunnel2_preshared_key
  router                          = google_compute_router.gcp-router.name
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha-vpn-gw-a.self_link
  vpn_gateway_interface           = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.0.id
}

resource "google_compute_vpn_tunnel" "tunnel-to-aws-connection-1-ip0" {
  provider = google-beta

  name = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-vpn-tunnel-2-ip-1"

  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = google_compute_external_vpn_gateway.external_gateway.interface.2.id
  region                          = var.gcp_region
  ike_version                     = 2
  shared_secret                   = aws_vpn_connection.aws-vpn-connection2.tunnel1_preshared_key
  router                          = google_compute_router.gcp-router.name
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha-vpn-gw-a.self_link
  vpn_gateway_interface           = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.1.id
}

resource "google_compute_vpn_tunnel" "tunnel-to-aws-connection-1-ip1" {
  provider = google-beta

  name = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-vpn-tunnel-2-ip-2"

  peer_external_gateway           = google_compute_external_vpn_gateway.external_gateway.self_link
  peer_external_gateway_interface = google_compute_external_vpn_gateway.external_gateway.interface.3.id
  region                          = var.gcp_region
  ike_version                     = 2
  shared_secret                   = aws_vpn_connection.aws-vpn-connection2.tunnel2_preshared_key
  router                          = google_compute_router.gcp-router.name
  vpn_gateway                     = google_compute_ha_vpn_gateway.ha-vpn-gw-a.self_link
  vpn_gateway_interface           = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.1.id
}

/*
 * ------------GCP STEP 6------------
 * -----ASSIGN BGP IP ADDRESSES------
 */

# FIRST VPN TUNNEL
resource "google_compute_router_interface" "router_interface1" {
  name = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-interface-1"

  router     = google_compute_router.gcp-router.name
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-to-aws-connection-0-ip0.name
  ip_range   = "${aws_vpn_connection.aws-vpn-connection1.tunnel1_cgw_inside_address}/30"
  region     = var.gcp_region
}

resource "google_compute_router_peer" "gcp-to-aws-bgp1" {
  name            = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-peer-bgp-1"
  router          = google_compute_router.gcp-router.name
  peer_asn        = aws_vpn_connection.aws-vpn-connection1.tunnel1_bgp_asn
  peer_ip_address = aws_vpn_connection.aws-vpn-connection1.tunnel1_vgw_inside_address
  interface       = google_compute_router_interface.router_interface1.name
  region          = var.gcp_region
}

# SECOND VPN TUNNEL
resource "google_compute_router_interface" "router_interface2" {
  name       = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-interface-2"
  router     = google_compute_router.gcp-router.name
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-to-aws-connection-0-ip1.name
  ip_range   = "${aws_vpn_connection.aws-vpn-connection1.tunnel2_cgw_inside_address}/30"
  region     = var.gcp_region
}

resource "google_compute_router_peer" "gcp-to-aws-bgp2" {
  name            = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-peer-bgp-2"
  router          = google_compute_router.gcp-router.name
  peer_asn        = aws_vpn_connection.aws-vpn-connection1.tunnel2_bgp_asn
  peer_ip_address = aws_vpn_connection.aws-vpn-connection1.tunnel2_vgw_inside_address
  interface       = google_compute_router_interface.router_interface2.name
  region          = var.gcp_region
}

# THIRD VPN TUNNEL
resource "google_compute_router_interface" "router_interface3" {
  name       = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-interface-3"
  router     = google_compute_router.gcp-router.name
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-to-aws-connection-1-ip0.name
  ip_range   = "${aws_vpn_connection.aws-vpn-connection2.tunnel1_cgw_inside_address}/30"
  region     = var.gcp_region
}

resource "google_compute_router_peer" "gcp-to-aws-bgp3" {
  name            = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-peer-bgp-3"
  router          = google_compute_router.gcp-router.name
  peer_asn        = aws_vpn_connection.aws-vpn-connection2.tunnel1_bgp_asn
  peer_ip_address = aws_vpn_connection.aws-vpn-connection2.tunnel1_vgw_inside_address
  interface       = google_compute_router_interface.router_interface3.name
  region          = var.gcp_region
}

# FOURTH VPN TUNNEL
resource "google_compute_router_interface" "router_interface4" {
  name       = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-interface-4"
  router     = google_compute_router.gcp-router.name
  vpn_tunnel = google_compute_vpn_tunnel.tunnel-to-aws-connection-1-ip1.name
  ip_range   = "${aws_vpn_connection.aws-vpn-connection2.tunnel2_cgw_inside_address}/30"
  region     = var.gcp_region
}

resource "google_compute_router_peer" "gcp-to-aws-bgp4" {
  name            = "${var.gcp_network_name}-to-${var.aws_transit_gateway_id}-router-peer-bgp-4"
  router          = google_compute_router.gcp-router.name
  peer_asn        = aws_vpn_connection.aws-vpn-connection2.tunnel2_bgp_asn
  peer_ip_address = aws_vpn_connection.aws-vpn-connection2.tunnel2_vgw_inside_address
  interface       = google_compute_router_interface.router_interface4.name
  region          = var.gcp_region
}
