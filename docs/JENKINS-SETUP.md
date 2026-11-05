# Jenkins setup

## Jenkins host
Use a secured Jenkins LTS installation with Java 17, Git, Maven 3.9+ and OpenSSH client. Install plugins: Pipeline, Git, GitHub integration, SSH Agent, JUnit and Workspace Cleanup. Restrict Jenkins access and keep it patched.

## GitHub repository
Create a repository, then push this project:
```bash
git init
git add .
git commit -m "Initial enterprise portal CI/CD project"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/enterprise-cicd-devops.git
git push -u origin main
```

## Jenkins credentials
Manage Jenkins -> Credentials -> Global -> Add:
- ID: `ec2-ssh-key`
- Type: SSH Username with private key
- Username: `deploy`
- Private key: matching the public key in EC2 `/home/deploy/.ssh/authorized_keys`

Never store private keys, passwords or tokens in Git.

## Pipeline job
1. New Item -> Pipeline.
2. Definition: Pipeline script from SCM.
3. SCM: Git; repository URL and credentials if private.
4. Branch: `*/main`.
5. Script path: `Jenkinsfile`.
6. Edit Jenkinsfile values `DEPLOY_HOST`, `DEPLOY_USER`, `SSH_CREDENTIALS_ID`.

The sample uses `ssh-keyscan` for a lab. Production should pin and verify the EC2 host key out-of-band rather than trusting a key fetched during the build.

## Webhook
GitHub repository -> Settings -> Webhooks -> Add webhook:
- Payload URL: `https://YOUR-JENKINS-DOMAIN/github-webhook/`
- Content type: `application/json`
- Event: push
Configure webhook secret validation in the GitHub/Jenkins integration. Enable "GitHub hook trigger for GITScm polling" in the job. GitHub must be able to reach Jenkins; do not expose an unsecured controller. For a private lab, use polling instead.

## Test it
Change a line in HomeServlet, then:
```bash
git add .
git commit -m "Update portal"
git push origin main
```
Jenkins checks out, runs Maven tests/package, archives the WAR, transfers it to EC2 and calls the deployment helper. The helper checks `/enterprise-portal/health` and fails the build if deployment cannot be verified.
