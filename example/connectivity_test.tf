# AWS INSTANCE
resource "aws_instance" "aws-vm" {
  ami           = "ami-0713f98de93617bb4"
  instance_type = "t3.micro"
  key_name      = var.aws_key_pair
  subnet_id     = data.aws_subnet.selected.id

  vpc_security_group_ids = [ aws_security_group.aws-allow-ssh.id ]

  tags = {
    Name = "aws-to-gcp-test-${var.aws_region}"
  }
}

# AWS SECURITY GROUP
# Allow SSH for iperf testing.
resource "aws_security_group" "aws-allow-ssh" {
  name        = "aws-allow-ssh-icmp-gcp"
  description = "Allow ssh and icmp access from anywhere. All everything from gcp"
  vpc_id      = data.aws_vpc.aws-vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ var.gcp_subnet1_cidr ]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# GCP Instance
data "google_compute_zones" "available" {
  region = var.gcp_region
}

resource "google_compute_instance" "gcp-vm" {
  name         = "gcp-vm-${var.gcp_region}"
  machine_type = "n1-standard-1"
  zone         = data.google_compute_zones.available.names[0]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.gcp-subnet1.name
  }
}

# GCP SECURITY GROUP
# Allow PING testing.
resource "google_compute_firewall" "gcp-allow-icmp-and-ssh-and-http-and-https" {
  name    = "${google_compute_network.gcp-network.name}-gcp-allow-icmp-and-ssh-and-http-and-https"
  network = google_compute_network.gcp-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443"]
  }

  source_ranges = [
    "0.0.0.0/0",
  ]
}

# Allow traffic from the VPN subnets.
resource "google_compute_firewall" "gcp-allow-vpn" {
  name    = "${google_compute_network.gcp-network.name}-gcp-allow-vpn"
  network = google_compute_network.gcp-network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [
    data.aws_subnet.selected.cidr_block
  ]
}
