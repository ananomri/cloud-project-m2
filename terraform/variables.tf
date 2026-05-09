variable "aws_region" {
  description = "Région AWS"#saffiche dans terraform plan
  type        = string
  default     = "us-east-1"
}

variable "project_name" {#pref pour nommer tts les ressources
  description = "Nom du projet"
  type        = string
  default     = "cloud-project"
}

variable "db_password" {
  description = "Mot de passe RDS"
  type        = string
  sensitive   = true #Cache la valeur dans les logs
}

variable "db_username" {
  description = "Utilisateur RDS"
  type        = string
  default     = "admin"
}

variable "my_ip" {
  description = "IP pour SSH (format: x.x.x.x/32)"
  type        = string
  default     = "158.12.10.0/32"
}

#SANDBOX OPTIONS

variable "use_existing_key" {
  description = "TRUE = utiliser une cle existante du sandbox, FALSE = Terraform cree la cle"
  type        = bool
  default     = true
}

variable "existing_key_name" {
  description = "Nom de la cle SSH deja existante dans le sandbox (ex: vockey, aws-sandbox-key)"
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
  default     = "db.t3.micro"
}
