resource "google_compute_region_instance_group_manager" "web" {
  name = "web-manager"

  base_instance_name         = "web"
  region                     = var.gcp_region
  distribution_policy_zones  = ["us-east1-b", "us-east1-c", "us-east1-d"] # TODO(tobi): Hacer dinamico

  version {
    instance_template = google_compute_instance_template.web.id
  }
  
  target_size  = 2
  auto_healing_policies {
    health_check      = google_compute_health_check.tcp-health-check.id
    initial_delay_sec = 300
  }
}

resource "google_compute_instance_template" "web" {
  name                 = "web-template"

  machine_type         = "e2-micro"
  can_ip_forward       = false

  tags                 = ["web-server", "allow-hc"]

  // Create a new boot disk from an image
 disk {
    source_image      = "debian-cloud/debian-9"
    auto_delete       = true
    boot              = true
  }

  network_interface {
    network = google_compute_network.vpc_network.id
    subnetwork = google_compute_subnetwork.subnet-priv-1.id
    access_config {
    }
  }

  metadata_startup_script = "${file("scripts/web_server_init_script.sh")}"
}


resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }
}