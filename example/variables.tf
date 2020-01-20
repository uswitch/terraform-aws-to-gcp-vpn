
variable "aws_vpc_name" {
  description = "VPC to connect to/from"
}
variable "aws_subnet_name" {
  description = "Subnet that exists in a VPC name"
}
variable "aws_route_table_name" {
 description = "Route Table that is associated with aws_subnet_name"
}

variable "aws_key_pair" {
  description = "Exisitng key pair name, used to ssh on to instance"
}

variable aws_region {
  description = "Default to Ireland region."
  default     = "eu-west-1"
}

variable "aws_side_asn" {
  default = "64512"
  description = "The Autonomous System Number (ASN) for the Amazon side of the gateway. If you don't specify an ASN, the virtual private gateway is created with the default ASN (64512)."
}

variable gcp_side_asn {
  default = "65000"
  description = "Any private ASN (64512-65534, 4200000000-4294967294) that you are not already using in the peer network. The ASN is used for all BGP sessions on the same Cloud Router, and it cannot be changed later."
}

variable gcp_credentials_file_path {
  description = "Locate the GCP credentials .json file."
}
variable "gcp_project_id" {
  description = "Existing GCP Project"
}

variable gcp_region {
  description = "Default to London region."
  default = "europe-west2"
}

variable gcp_subnet1_cidr {
  description = "Cidr range for GCP subnet"
}
variable gcp_subnet2_cidr {
  description = "Cidr range for GCP subnet"
}
