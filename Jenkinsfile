pipeline {
    agent any

    environment {
        SNYK_TOKEN = credentials('SNYK_TOKEN')
    }

    stages {
        stage('Download Snyk CLI, snyk-to-html') {
            steps {
                sh '''
                    curl -Lo ./snyk "https://static.snyk.io/cli/latest/snyk-linux"
                    curl -Lo ./snyk-to-html "https://github.com/snyk/snyk-to-html/releases/download/v2.3.1/snyk-to-html-linux"
                    chmod +x snyk
                    chmod +x snyk-to-html
                '''
            }
        }

        stage('Snyk Code Test using Snyk CLI') {
            steps {
                sh './snyk code test --json | ./snyk-to-html -o snyk-code.html'
            }
        }

        stage('Snyk Test using Snyk CLI') {
            steps {
                sh './snyk test --json | ./snyk-to-html -o snyk-opensource.html'
            }
        }

        stage('Publish Snyk Code Report') {
            steps {
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'snyk-code.html',
                    reportName: "Snyk Code Report"
                ])
            }
        }

        stage('Publish Snyk Open Source Report') {
            steps {
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'snyk-opensource.html',
                    reportName: "Snyk Open Source Report"
                ])
            }
        }
    }
}