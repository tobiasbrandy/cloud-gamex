output "domain_name" {
  description = "Domain name of ecs services load balancer"
  value       = aws_lb.main.dns_name
}