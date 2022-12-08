pipeline {
    agent any

    environment {
        SNYK_TOKEN = credentials('SNYK_TOKEN')
    }

    stages {
        
        stage('Run Snyk Open Source') {
            steps {
                snykSecurity(
                    failOnIssues: false,
                    monitorProjectOnBuild: false,
                    snykInstallation: 'snyk-plugin'
                )
            }
        }

        stage('Run Snyk Code') {
            steps {
                snykSecurity(
                    failOnIssues: false,
                    monitorProjectOnBuild: false,
                    snykInstallation: 'snyk-plugin',
                    additionalArguments: '--code'
                )
            }
        }
        
        stage('Run Snyk IaC') {
            steps {
                snykSecurity(
                    failOnIssues: false,
                    monitorProjectOnBuild: false,
                    snykInstallation: 'snyk-plugin',
                    additionalArguments: '--iac'
                )
            }
        }
    }
}
