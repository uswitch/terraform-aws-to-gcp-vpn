variable "aws_vpc_id" {
  description = "AWS VPC to connect to/from"
  type        = string
}
variable aws_region {
  description = "Default to Ireland region."
  default     = "eu-west-1"
}
variable bgp_asn {
  default = "65000"
  description = "Any private ASN (64512-65534, 4200000000-4294967294) that you are not already using in the peer network. The ASN is used for all BGP sessions on the same Cloud Router, and it cannot be changed later."
}

variable gcp_network_name {
  description = "GCP Network to connect to/from"
}

variable gcp_region {
  description = "Default to London region."
  default     = "europe-west2"
}
