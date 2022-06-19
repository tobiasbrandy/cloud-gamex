output "domain_name" {
  description = "Domain name of load balancer"
  value       = aws_lb.main.dns_name
}

output "services_target_group" {
  description = "Target group of ALB redirecting to services"
  value       = aws_alb_target_group.services
}