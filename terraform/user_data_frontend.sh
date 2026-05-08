#!/bin/bash
set -e

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

echo "=== [1/4] Mise à jour et installation de Nginx + git ==="
apt-get update -y
apt-get install -y nginx git

echo "=== [2/4] Clonage du dépôt GitHub ==="
cd /tmp
rm -rf app || true
git clone --depth 1 https://github.com/ananomri/cloud-project-m2.git app


echo "=== [3/4] Déploiement des fichiers frontend ==="
mkdir -p /var/www/cloud-project

# Copie des fichiers statiques
cp /tmp/app/index.html /var/www/cloud-project/
cp /tmp/app/style.css  /var/www/cloud-project/
cp /tmp/app/script.js  /var/www/cloud-project/

echo "=== Fichiers frontend (debug) ==="
ls -lah /var/www/cloud-project
head -n 3 /var/www/cloud-project/index.html || true


# Injection automatique du DNS de l'ALB dans script.js
# Remplace le placeholder REPLACE_WITH_ALB_DNS par la vraie valeur fournie par Terraform
sed -i 's|REPLACE_WITH_ALB_DNS|${alb_dns}|g' /var/www/cloud-project/script.js

echo "=== [4/4] Configuration et démarrage de Nginx ==="
cat > /etc/nginx/sites-available/cloud-project << 'NGINXEOF'
server {
    listen 80;
    server_name _;
    root /var/www/cloud-project;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
NGINXEOF

ln -sf /etc/nginx/sites-available/cloud-project /etc/nginx/sites-enabled/cloud-project
# Désactive/supprime le site par défaut (pour éviter la page "Welcome to nginx!")
rm -f /etc/nginx/sites-enabled/default /etc/nginx/sites-available/default || true

# Vérifie que seul notre site est activé
nginx -t
systemctl restart nginx
systemctl enable nginx

echo "=== Frontend déployé avec succès ==="
echo "ALB DNS injecté : ${alb_dns}"
