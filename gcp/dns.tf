resource "google_dns_managed_zone" "main" {
  name        = "gcp-dns"
  dns_name    = "gcp.redes.tobiasbrandy.com."
  description = "Application deployment on GCP DNS"
}

resource "google_dns_record_set" "main" {
  name = google_dns_managed_zone.main.dns_name
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.main.name

  rrdatas = [data.google_compute_global_address.default.address]
}
