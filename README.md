# Enterprise Portal – DevOps CI/CD Lab

A production-style learning project: GitHub push -> webhook -> Jenkins -> Maven tests/build -> WAR -> SSH/SCP -> AWS EC2 Ubuntu -> Apache Tomcat. Nginx is the public reverse proxy. Deployment includes backup, health verification and rollback.

## Stack
Java 17, Jakarta Servlet 6, Maven, Git/GitHub, Jenkins Pipeline, AWS EC2, Ubuntu, SSH, Apache Tomcat 10.1, Nginx, JUnit.

## Layout
- `src/`: Java web application
- `pom.xml`: Maven WAR build
- `Jenkinsfile`: CI/CD pipeline
- `scripts/install-server.sh`: EC2 setup
- `scripts/deploy.sh`: backup/deploy/health-check/rollback
- `docs/`: AWS, Jenkins, operations and interview instructions

## Local build
```bash
mvn clean test package
```
WAR: `target/enterprise-portal.war`

Read `docs/AWS-SETUP.md`, then `docs/JENKINS-SETUP.md`. Do not commit credentials or private keys.

## Important
This is a single-instance production-style lab, not a highly available production architecture. For real production add TLS, private subnets, load balancing, multi-AZ capacity, least-privilege IAM, centralized logs/metrics, artifact storage, scanning, approvals and tested disaster recovery.
