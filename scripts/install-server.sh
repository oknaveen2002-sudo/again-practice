#!/usr/bin/env bash
set -euo pipefail
sudo apt-get update
sudo apt-get install -y openjdk-17-jdk nginx curl wget
TOMCAT_VERSION="10.1.61"
TOMCAT_DIR="/opt/tomcat"
id tomcat >/dev/null 2>&1 || sudo useradd --system --home "$TOMCAT_DIR" --shell /usr/sbin/nologin tomcat
cd /tmp
wget -q "https://dlcdn.apache.org/tomcat/tomcat-10/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz"
sudo mkdir -p "$TOMCAT_DIR"
sudo tar -xzf "apache-tomcat-${TOMCAT_VERSION}.tar.gz" --strip-components=1 -C "$TOMCAT_DIR"
sudo chown -R tomcat:tomcat "$TOMCAT_DIR"
sudo chmod +x "$TOMCAT_DIR"/bin/*.sh
sudo tee /etc/systemd/system/tomcat.service >/dev/null <<'UNIT'
[Unit]
Description=Apache Tomcat 10.1
After=network.target
[Service]
Type=forking
User=tomcat
Group=tomcat
Environment="JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
Restart=on-failure
RestartSec=5
UMask=0027
[Install]
WantedBy=multi-user.target
UNIT
sudo systemctl daemon-reload
sudo systemctl enable --now tomcat
id deploy >/dev/null 2>&1 || sudo useradd -m -s /bin/bash deploy
sudo install -d -o deploy -g deploy -m 0750 /home/deploy/staging
sudo install -d -o deploy -g deploy -m 0750 /opt/deploy-backups
sudo install -o root -g root -m 0755 "$(dirname "$0")/deploy.sh" /usr/local/sbin/deploy-enterprise-portal
sudo tee /etc/nginx/sites-available/enterprise-portal >/dev/null <<'NGINX'
server {
 listen 80 default_server;
 server_name _;
 server_tokens off;
 location / {
  proxy_pass http://127.0.0.1:8080;
  proxy_http_version 1.1;
  proxy_set_header Host $host;
  proxy_set_header X-Real-IP $remote_addr;
  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  proxy_set_header X-Forwarded-Proto $scheme;
 }
}
NGINX
sudo ln -sfn /etc/nginx/sites-available/enterprise-portal /etc/nginx/sites-enabled/enterprise-portal
sudo rm -f /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl enable --now nginx
sudo systemctl reload nginx
echo "Install complete. Configure deploy SSH key and restricted sudo rule using docs/AWS-SETUP.md."
