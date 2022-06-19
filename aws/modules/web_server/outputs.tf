output "domain_name" {
  description = "Domain Name of the public load balancer"
  value       = aws_lb.web.dns_name
}
