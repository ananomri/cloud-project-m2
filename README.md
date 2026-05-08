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

## 📁 Structure du dépôt

```
cloud-project/
├── server.js              ← API Node.js (backend)
├── package.json           ← Dépendances Node.js
├── index.html             ← Page principale (frontend)
├── style.css              ← Styles
├── script.js              ← JS frontend (contient REPLACE_WITH_ALB_DNS)
│
├── main.tf                ← Provider AWS + AMI Ubuntu
├── variables.tf           ← Déclaration des variables
├── terraform.tfvars       ← ⚠️ Vos valeurs (PAS sur Git)
├── vpc.tf                 ← VPC, sous-réseaux, IGW, NAT, routes
├── alb.tf                 ← ALB, Target Group, Listener
├── asg_backend.tf         ← Launch Template, ASG, Scaling Policy
├── ec2_frontend.tf        ← Instance EC2 frontend
├── rds.tf                 ← RDS MySQL
├── security_groups.tf     ← SG ALB, Backend, RDS, Frontend
├── outputs.tf             ← Affichage des URLs après déploiement
│
├── user_data_backend.sh   ← Script démarrage EC2 backend (git clone + npm start)
└── user_data_frontend.sh  ← Script démarrage EC2 frontend (git clone + nginx)
```

---

## 🚀 Étapes de déploiement

### ÉTAPE 1 — Préparer le dépôt GitHub

```bash
# 1. Créez un dépôt PUBLIC sur https://github.com/new
#    Nom suggéré : cloud-project

# 2. Dans ce dossier, initialisez git
git init
git add .
git commit -m "initial commit"
git branch -M main
git remote add origin https://github.com/VOTRE_USERNAME/VOTRE_REPO.git
git push -u origin main
```

### ÉTAPE 2 — Mettre à jour l'URL GitHub dans les scripts

Éditez **user_data_backend.sh** et **user_data_frontend.sh**, remplacez :
```
https://github.com/VOTRE_USERNAME/VOTRE_REPO.git
```
par votre vraie URL GitHub, puis re-committez :
```bash
git add user_data_backend.sh user_data_frontend.sh
git commit -m "update github url"
git push
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
```

---

## 🔒 Security Groups (ce qui est contrôlé)

| Composant | Entrant | Depuis |
|-----------|---------|--------|
| ALB | port 80 | 0.0.0.0/0 (internet) |
| EC2 Backend | port 3000 | SG de l'ALB uniquement |
| RDS | port 3306 | SG du Backend uniquement |
| EC2 Frontend | port 80 | 0.0.0.0/0 (internet) |
| EC2 Frontend | port 22 | Votre IP uniquement |

---

## 📡 API Endpoints

| Méthode | Route | Description |
|---------|-------|-------------|
| GET | /health | Health check ALB |
| GET | /api/messages | Liste des messages |
| POST | /api/messages | Créer un message |
| GET | /api/info | Info instance |
