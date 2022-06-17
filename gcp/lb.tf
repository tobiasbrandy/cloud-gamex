resource "google_compute_global_forwarding_rule" "forwarding" {
  provider              = google
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.default.id
  ip_address            = google_compute_global_address.default.id
}
resource "google_compute_global_address" "default" {
  provider = google
  name     = "static-ip"
}

data "google_compute_global_address" "default" {
  name = "static-ip"
  depends_on = [
    google_compute_global_address.default
  ]
}

resource "google_compute_target_http_proxy" "default" {
  name     = "lb-target-http-proxy"
  provider = google
  url_map  = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name            = "lb-url-map"
  provider        = google
  default_service = google_compute_backend_bucket.ice-cream-bucket.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.ice-cream-bucket.id

    path_rule {
      paths   = ["/api","/api/*"]
      service = google_compute_backend_service.backend.id
    }

    path_rule {
      paths   = ["/bucket", "/bucket/*"]
      service = google_compute_backend_bucket.ice-cream-bucket.id
    }
  }
}


resource "google_compute_backend_service" "backend" {
  provider              = google
  name                  = "ilb-backend-subnet"
  protocol              = "HTTP"
  port_name             = "my-port"
  load_balancing_scheme = "EXTERNAL"
  enable_cdn            = true

  health_checks = [google_compute_health_check.default.id]
  backend {
    group           = google_compute_region_instance_group_manager.web.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

resource "google_compute_backend_bucket" "ice-cream-bucket" {
  name = "ice-cream-backend-bucket"

  bucket_name = google_storage_bucket.ice-cream-bucket.id
  enable_cdn  = true
}

# health check
resource "google_compute_health_check" "default" {
  name     = "lb-hc"
  provider = google
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}
