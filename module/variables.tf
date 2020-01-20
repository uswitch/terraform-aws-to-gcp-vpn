variable "aws_vpc_id" {
  description = "VPC to connect to/from"
  type        = string
}
variable aws_region {
  description = "Default to Ireland region."
  default     = "eu-west-1"
}
variable bgp_asn {}

variable gcp_network_name {}
variable gcp_subnet1_cidr {}
variable gcp_subnet2_cidr {}
variable gcp_region {
  default = "europe-west1"
}
