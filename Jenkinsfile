pipeline {
  agent any
  options { timestamps(); disableConcurrentBuilds(); buildDiscarder(logRotator(numToKeepStr: '20')); timeout(time: 20, unit: 'MINUTES') }
  environment {
    APP_NAME = 'enterprise-portal'
    DEPLOY_HOST = 'REPLACE_WITH_EC2_PUBLIC_DNS_OR_IP'
    DEPLOY_USER = 'deploy'
    SSH_CREDENTIALS_ID = 'ec2-ssh-key'
    REMOTE_STAGING = '/home/deploy/staging'
  }
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build and Test') {
      steps { sh 'mvn -B clean test package' }
      post {
        always {
          junit allowEmptyResults: true, testResults: 'target/surefire-reports/*.xml'
          archiveArtifacts artifacts: 'target/*.war', fingerprint: true
        }
      }
    }
    stage('Deploy to AWS EC2') {
      when { expression { env.BRANCH_NAME == 'main' || env.GIT_BRANCH == 'origin/main' } }
      steps {
        sshagent(credentials: [env.SSH_CREDENTIALS_ID]) {
          sh '''
            set -eu
            test -f target/${APP_NAME}.war
            mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
            ssh-keyscan -H "$DEPLOY_HOST" >> "$HOME/.ssh/known_hosts"
            scp -o StrictHostKeyChecking=yes target/${APP_NAME}.war ${DEPLOY_USER}@${DEPLOY_HOST}:${REMOTE_STAGING}/${APP_NAME}.war
            ssh -o StrictHostKeyChecking=yes ${DEPLOY_USER}@${DEPLOY_HOST} "sudo /usr/local/sbin/deploy-enterprise-portal ${REMOTE_STAGING}/${APP_NAME}.war"
          '''
        }
      }
    }
  }
  post {
    success { echo 'Pipeline completed successfully.' }
    failure { echo 'Pipeline failed. Review logs before retrying.' }
    always { cleanWs() }
  }
}
