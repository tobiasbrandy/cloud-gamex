output "domain_name" {
  description = "Domain name of load balancer"
  value       = aws_lb.main.dns_name
}