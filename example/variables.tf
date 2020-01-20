
variable "aws_vpc_name" {
  description = "VPC to connect to/from"
  type        = string
}
variable "aws_subnet_name" {
  type = string
}
variable "aws_route_table_name" {
  type = string
}

variable "aws_key_pair" {}

variable aws_region {
  description = "Default to Ireland region."
  default     = "eu-west-1"
}

variable bgp_asn {}

variable gcp_credentials_file_path {
  description = "Locate the GCP credentials .json file."
  type        = string
}
variable "gcp_project_id" {
  type = string
}

variable gcp_region {
  default = "europe-west1"
}

variable gcp_subnet1_cidr {}
variable gcp_subnet2_cidr {}
