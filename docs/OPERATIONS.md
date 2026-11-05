# Operations

## URLs
- Homepage: `http://EC2_PUBLIC_DNS/enterprise-portal/`
- Health: `http://EC2_PUBLIC_DNS/enterprise-portal/health`

## Commands
```bash
sudo systemctl status tomcat nginx
sudo systemctl restart tomcat
sudo journalctl -u tomcat -n 100 --no-pager
sudo tail -n 100 /opt/tomcat/logs/catalina.out
sudo nginx -t
sudo tail -n 100 /var/log/nginx/error.log
curl -i http://127.0.0.1:8080/enterprise-portal/health
curl -i http://127.0.0.1/enterprise-portal/health
```

## Troubleshooting
- SSH failure: security group TCP 22, route, username, SSH key and permissions.
- WAR build failure: Java/Maven versions and compiler output.
- 404: WAR filename/context path and Tomcat logs.
- Nginx 502: Tomcat status and local port 8080.
- Health check timeout: `catalina.out`, servlet startup errors, CPU/memory and port conflict.

The deploy helper stores previous WARs in `/opt/deploy-backups/` and restores the prior WAR if the new deployment fails its health check. This is a basic lab rollback; production should use immutable versioned artifacts and a controlled release strategy.
