# Output variable definitions

output "cloudfront_distribution" {
  description = "The cloudfront distribution for the deployment"
  value       = aws_cloudfront_distribution.redes
}
