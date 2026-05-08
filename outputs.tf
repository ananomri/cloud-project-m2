output "alb_dns_name" {
  description = "DNS de l'ALB"
  value       = aws_lb.main.dns_name
}

output "frontend_public_ip" {
  description = "IP publique du serveur frontend"
  value       = aws_instance.frontend.public_ip
}

output "frontend_url" {
  description = "URL du frontend"
  value       = "http://${aws_instance.frontend.public_ip}"
}

output "rds_endpoint" {
  description = "Endpoint de la base de données RDS"
  value       = aws_db_instance.main.endpoint
}

output "ssh_command_frontend" {
  description = "Commande SSH pour le frontend"
  value       = "ssh -i ~/.ssh/${var.existing_key_name}.pem ubuntu@${aws_instance.frontend.public_ip}"
}