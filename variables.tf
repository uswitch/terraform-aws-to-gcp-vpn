variable "aws_transit_gateway_id" {
  description = "AWS transit gateway to connect to/from"
  type        = string
}

variable aws_region {
  description = "Default to Ireland region."
  default     = "eu-west-1"
}

variable "aws_side_asn" {
  default     = "64512"
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. If you don't specify an ASN, the virtual private gateway is created with the default ASN (64512)."
}

variable gcp_side_asn {
  default     = "65000"
  description = "Any private ASN (64512-65534, 4200000000-4294967294) that you are not already using in the peer network. The ASN is used for all BGP sessions on the same Cloud Router, and it cannot be changed later."
}

variable gcp_network_name {
  description = "GCP Network to connect to/from"
}

variable gcp_region {
  description = "Default to London region."
  default     = "europe-west2"
}

variable gcp_cidrs {
  type = list(object({
    cidr = string
    description = string
  }))
  default = []
}
