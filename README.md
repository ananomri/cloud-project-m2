# ☁️ Projet Cloud AWS — Full-Stack sur Terraform

Application Full-Stack (Node.js + MySQL + HTML/JS) déployée sur AWS avec Terraform.

## 🏗️ Architecture

```
Internet
   │
   ▼
[EC2 Frontend - sous-réseau PUBLIC]   ← Nginx sert index.html/style.css/script.js
   │ appelle via DNS ALB
   ▼
[ALB - sous-réseaux PUBLICS]          ← Répartit le trafic HTTP port 80
   │
   ▼
[ASG Backend - sous-réseaux PRIVÉS]   ← 2 instances EC2, Node.js port 3000
   │
   ▼
[RDS MySQL - sous-réseaux PRIVÉS]     ← Base de données, jamais exposée
```

---

## 🚀 Étapes de déploiement


```bash

# 2. Dans ce dossier, initialisez git
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/ananomri/cloud-project-m2.git
git push -u origin main
```



### ÉTAPE 3 — Configurer terraform.tfvars

Créez/éditez `terraform.tfvars` avec vos valeurs :
```hcl
aws_region        = "us-east-1"
project_name      = "cloud-project"
db_password       = "MonSuperMotDePasse123!"
db_username       = "admin"
my_ip             = "X.X.X.X/32"   # votre IP : https://checkip.amazonaws.com
use_existing_key  = true
existing_key_name = "vockey"        # nom de la clé dans votre sandbox
instance_type     = "t2.micro"
rds_instance_class = "db.t3.micro"
```

> ⚠️ `terraform.tfvars` est dans `.gitignore` — ne le poussez PAS sur GitHub !

### ÉTAPE 4 — Lancer Terraform

```bash
# Se placer dans le dossier terraform
cd cloud-project/

# Initialiser Terraform (télécharge le provider AWS)
terraform init

# Vérifier ce qui va être créé (lecture seule)
terraform plan

# Déployer l'infrastructure (~5-10 minutes)
terraform apply
# Tapez "yes" quand demandé
```

### ÉTAPE 5 — Récupérer les URLs

Après `terraform apply`, les outputs s'affichent :
```
alb_dns_name      = "cloud-project-alb-XXXX.us-east-1.elb.amazonaws.com"
frontend_url      = "http://X.X.X.X"
frontend_public_ip = "X.X.X.X"
rds_endpoint      = "cloud-project-db.XXXX.us-east-1.rds.amazonaws.com"
```

Ouvrez **frontend_url** dans votre navigateur. ✅

---

## 🧹 Détruire l'infrastructure

```bash
terraform destroy
# Tapez "yes" — supprime TOUT (EC2, ALB, RDS, VPC...)
