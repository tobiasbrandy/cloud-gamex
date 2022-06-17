
resource "google_compute_network" "vpc_network" {
  project                 = var.gcp_project
  name                    = "vpc-network"
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet-priv-1" {
  name          = "subnet-priv-1"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
  project       = var.gcp_project

  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}