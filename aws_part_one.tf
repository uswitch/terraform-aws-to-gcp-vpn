/*
 * ------------AWS STEP 1------------
 * -CREATE A SITE-TO-SITE CONNECTION-
 * ------CREATE CUSTOMER GATEWAY-----
 */

resource "aws_vpn_connection" "aws-vpn-connection1" {
  transit_gateway_id      = var.aws_transit_gateway_id
  customer_gateway_id = aws_customer_gateway.aws-cgw-one.id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = {
    Name       = "${var.aws_transit_gateway_id}-to-${var.gcp_network_name}-vpn-connection-1"
    Created-By = "terraform"
  }
}

resource "aws_customer_gateway" "aws-cgw-one" {
  bgp_asn    = google_compute_router.gcp-router.bgp[0].asn
  ip_address = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.0.ip_address
  type       = "ipsec.1"

  tags = {
    Name       = "${var.aws_transit_gateway_id}-to-${var.gcp_network_name}-customer-gateway-1"
    Created-By = "terraform"
  }
}

/*
 * ------------AWS STEP 2------------
 * --CREATE SITE-TO-SITE CONNECTION--
 * --CREATE SECOND CUSTOMER GATEWAY--
 */

resource "aws_vpn_connection" "aws-vpn-connection2" {
  transit_gateway_id      = var.aws_transit_gateway_id
  customer_gateway_id = aws_customer_gateway.aws-cgw-two.id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = {
    Name       = "${var.aws_transit_gateway_id}-to-${var.gcp_network_name}-vpn-connection-2"
    Created-By = "terraform"
  }
}

resource "aws_customer_gateway" "aws-cgw-two" {
  bgp_asn    = google_compute_router.gcp-router.bgp[0].asn
  ip_address = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.1.ip_address
  type       = "ipsec.1"

  tags = {
    Name       = "${var.aws_transit_gateway_id}-to-${var.gcp_network_name}-customer-gateway-2"
    Created-By = "terraform"
  }
}

/*
 * -------GO TO GCP PART TWO-------
 */
