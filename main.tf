provider "google" {
  version     = "~> 3.4.0"
  project     = var.gcp_project_id
  credentials = file(var.gcp_credentials_file_path)

  region = var.gcp_region
}

provider "google-beta" {
  version     = "~> 3.4.0"
  project     = var.gcp_project_id
  credentials = file(var.gcp_credentials_file_path)

  region = var.gcp_region
}

provider "aws" {
  version = "~> 2.45.0"

  region = var.aws_region
}
