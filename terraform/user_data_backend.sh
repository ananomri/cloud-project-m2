#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "=== [1/5] Mise à jour et installation des outils ==="
apt-get update -y
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
apt-get install -y nodejs git mysql-client

echo "=== [2/5] Clonage du dépôt GitHub ==="
cd /home/ubuntu
rm -rf app || true
git clone https://github.com/ananomri/cloud-project-m2.git app
cd /home/ubuntu/app
npm install

echo "=== [3/5] Démarrage du backend avec les variables d'environnement ==="
export DB_HOST=${rds_endpoint}
export DB_USER=${db_username}
export DB_PASS=${db_password}
export DB_NAME=cloudapp
export PORT=3000

# pm2 pour garder le process vivant après la fin du script
npm install -g pm2
pm2 start server.js --name cloud-backend
pm2 startup systemd -u ubuntu --hp /home/ubuntu
pm2 save

echo "=== [4/5] Attente que RDS soit prêt (30s) ==="
sleep 30

echo "=== [5/5] Initialisation de la base de données ==="
mysql -h ${rds_endpoint} -u ${db_username} -p${db_password} << 'SQL'
CREATE DATABASE IF NOT EXISTS cloudapp;
USE cloudapp;
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  content TEXT NOT NULL,
  author VARCHAR(255) DEFAULT 'Anonyme',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
SQL

echo "=== Backend déployé avec succès ==="
