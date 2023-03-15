pipeline {
    agent any

    environment {
        SNYK_TOKEN = credentials('SNYK_TOKEN')
    }

    stages {

        stage('Download Latest Snyk CLI') {
            steps {
                sh '''
                    snyk_cli_dl_linux="https://static.snyk.io/cli/latest/snyk-linux"
                    echo "Download URL: ${snyk_cli_dl_linux}"
                    curl -Lo ./snyk "${snyk_cli_dl_linux}"
                    chmod +x snyk
                    ls -la
                    ./snyk -v
                '''
            }
        }

        stage('Download snyk-to-html') {
            steps {
                sh '''
                    snyk_html_dl_linux="https://github.com/snyk/snyk-to-html/releases/download/v2.3.1/snyk-to-html-linux"
                    echo "Download URL: ${snyk_html_dl_linux}"
                    curl -Lo ./snyk-to-html "${snyk_html_dl_linux}"
                    chmod +x snyk-to-html
                    ls -la
                    ./snyk-to-html -h
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

        stage('Publish Snyk Code Report') {
            steps {
                publishHTML(target: [
                    allowMissing: false,
                    alwaysLinkToLastBuild: false,
                    keepAll: true,
                    reportDir: '.',
                    reportFiles: 'snyk-opensource.html',
                    reportName: "Snyk Code Report"
                ])
            }
        }
    }
}