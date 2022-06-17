resource "google_compute_firewall" "weblb" {
  name    = "web-fw-lb-allow-ssh-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }

  direction = "INGRESS"

  source_ranges = ["${data.google_compute_global_address.default.address}/32"]

  target_tags = ["web-server"]
 
}

resource "google_compute_firewall" "allowhc" {
  ## firewall rules enabling the load balancer health checks
  name    = "allowhc-firewall"
  network =  google_compute_network.vpc_network.name

  description = "allow Google health checks and network load balancers access"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["35.191.0.0/16", "130.211.0.0/22", "209.85.152.0/22", "209.85.204.0/22"]
  target_tags   = ["allow-hc"]
}