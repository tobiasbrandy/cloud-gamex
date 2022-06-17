output "gcp_dns_name_servers" {
  description = "GCP Managed DNS Zone Name Servers"
  value       = google_dns_managed_zone.main.name_servers
}