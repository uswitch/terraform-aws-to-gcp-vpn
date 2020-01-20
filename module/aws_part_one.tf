/*
 * ------------AWS STEP 1------------
 * -----CREATE AWS VPN GATEWAY------
 * ----------ATTACH TO VPC-----------
 */
resource "aws_vpn_gateway" "aws-vpn-gw" {
  vpc_id = var.aws_vpc_id

  tags = {
    Name       = "${data.aws_vpc.aws-vpc.id}-to-${data.google_compute_network.gcp-network.name}-vpn-gateway"
    Created-By = "terraform"
  }
}

/*
 * ------------AWS STEP 2------------
 * -CREATE A SITE-TO-SITE CONNECTION-
 * ------CREATE CUSTOMER GATEWAY-----
 */

resource "aws_vpn_connection" "aws-vpn-connection1" {
  vpn_gateway_id      = aws_vpn_gateway.aws-vpn-gw.id
  customer_gateway_id = aws_customer_gateway.aws-cgw-one.id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = {
    Name       = "${data.aws_vpc.aws-vpc.id}-to-${data.google_compute_network.gcp-network.name}-vpn-connection-1"
    Created-By = "terraform"
  }
}

resource "aws_customer_gateway" "aws-cgw-one" {
  bgp_asn    = var.bgp_asn
  ip_address = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.0.ip_address
  type       = "ipsec.1"

  tags = {
    Name       = "${data.aws_vpc.aws-vpc.id}-to-${data.google_compute_network.gcp-network.name}-customer-gateway-1"
    Created-By = "terraform"
  }
}

/*
 * ------------AWS STEP 3------------
 * --CREATE SITE-TO-SITE CONNECTION--
 * --CREATE SECOND CUSTOMER GATEWAY--
 */

resource "aws_vpn_connection" "aws-vpn-connection2" {
  vpn_gateway_id      = aws_vpn_gateway.aws-vpn-gw.id
  customer_gateway_id = aws_customer_gateway.aws-cgw-two.id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = {
    Name       = "${data.aws_vpc.aws-vpc.id}-to-${data.google_compute_network.gcp-network.name}-vpn-connection-2"
    Created-By = "terraform"
  }
}

resource "aws_customer_gateway" "aws-cgw-two" {
  bgp_asn    = var.bgp_asn
  ip_address = google_compute_ha_vpn_gateway.ha-vpn-gw-a.vpn_interfaces.1.ip_address
  type       = "ipsec.1"

  tags = {
    Name       = "${data.aws_vpc.aws-vpc.id}-to-${data.google_compute_network.gcp-network.name}-customer-gateway-2"
    Created-By = "terraform"
  }
}

/*
 * -------GO TO GCP PART TWO-------
 */
