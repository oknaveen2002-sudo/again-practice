# AWS EC2 setup

1. Launch Ubuntu 22.04/24.04 EC2. Choose a lab-sized instance and check current AWS pricing/free-tier eligibility.
2. Create a key pair and store its private key securely.
3. Security Group inbound rules:
   - TCP 22 SSH: your current public IP only (or Jenkins agent's fixed egress IP).
   - TCP 80 HTTP: intended client IP ranges for the demo.
   - Do NOT expose TCP 8080 or Tomcat Manager publicly.
4. Note the public DNS/IP. Connect:
```bash
chmod 400 your-key.pem
ssh -i your-key.pem ubuntu@EC2_PUBLIC_DNS
```
5. Copy this repository to EC2, then run:
```bash
chmod +x scripts/*.sh
./scripts/install-server.sh
```
6. Add Jenkins public key to `/home/deploy/.ssh/authorized_keys`. Create `.ssh` owned by deploy with mode 700 and authorized_keys mode 600.
7. Allow only the fixed deployment helper through sudo:
```bash
sudo visudo -f /etc/sudoers.d/deploy-enterprise-portal
```
Add:
```text
deploy ALL=(root) NOPASSWD: /usr/local/sbin/deploy-enterprise-portal
```
Validate with `sudo visudo -cf /etc/sudoers.d/deploy-enterprise-portal`.

Verify:
```bash
sudo systemctl status tomcat nginx
curl -I http://127.0.0.1:8080/
```
The app appears after its first deployment. For production, prefer private subnets, Systems Manager or a controlled bastion, least-privilege IAM, TLS and load balancing.
