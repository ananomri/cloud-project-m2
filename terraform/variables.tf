variable "aws_region" {
  description = "Région AWS"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "cloud-project"
}

variable "db_password" {
  description = "Mot de passe RDS"
  type        = string
  default     = "SuperSecretPassword123!"
  sensitive   = true
}

variable "db_username" {
  description = "Utilisateur RDS"
  type        = string
  default     = "admin"
}

variable "my_ip" {
  description = "Votre IP pour SSH (format: x.x.x.x/32)"
  type        = string
  default     = "0.0.0.0/0"
}

# ==================== SANDBOX OPTIONS ====================

variable "use_existing_key" {
  description = "TRUE = utiliser une clé existante du sandbox, FALSE = Terraform crée la clé"
  type        = bool
  default     = true
}

variable "existing_key_name" {
  description = "Nom de la clé SSH déjà existante dans le sandbox (ex: vockey, aws-sandbox-key)"
  type        = string
  default     = "vockey"
}

variable "instance_type" {
  description = "Type d'instance EC2 (t2.micro pour sandbox AWS Academy)"
  type        = string
  default     = "t2.micro"
}

variable "rds_instance_class" {
  description = "Type d'instance RDS"
  type        = string
  default     = "db.t2.micro"
}
