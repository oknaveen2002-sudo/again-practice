# Interview explanation

## 60-second summary
"I built an automated CI/CD pipeline for a Java web application. Developers push code to GitHub. A webhook triggers Jenkins, which checks out the code, runs Maven unit tests and packages the application as a WAR. Jenkins archives the artifact and transfers it to an Ubuntu EC2 instance over SSH. A restricted deployment script backs up the previous WAR, deploys the new WAR to Apache Tomcat and verifies the health endpoint. Nginx acts as a reverse proxy. If the health check fails, the script attempts to restore the previous deployment. I also configured Linux services, SSH access, security groups and application logs."

## Tool responsibilities
- Git: local version control.
- GitHub: remote repository and collaboration.
- Webhook: notifies Jenkins of a push.
- Jenkins: pipeline orchestration.
- Maven: compile, test and package.
- WAR: deployable Java web application archive.
- EC2: virtual server in AWS.
- Security Group: instance-level network firewall.
- SSH/SCP: secure remote access and file transfer.
- Tomcat: servlet container that runs the WAR.
- Nginx: reverse proxy/public HTTP entry point.
- Health endpoint: confirms application responds.

## Questions to practise
1. CI vs CD?
2. What happens after a developer pushes code?
3. What is a Jenkinsfile?
4. JAR vs WAR?
5. Why does Tomcat run this WAR?
6. Why use Nginx?
7. What is an AWS Security Group?
8. Why keep port 8080 private?
9. How does Jenkins authenticate to EC2?
10. What happens if deployment fails?
11. Where are Tomcat logs?
12. How would you make this highly available?

Describe this honestly as a production-style hands-on lab. Do not claim HTTPS, autoscaling, monitoring dashboards, zero-downtime deployment or multi-AZ availability unless you implement them.
