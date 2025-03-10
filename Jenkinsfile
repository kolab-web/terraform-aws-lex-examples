pipeline {
    agent any
    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'eu-west-2'
    }
    tools {
        jdk       'jdk17'
        terraform 'terraform'
    }
    stages {
        stage('Checkout from Git') {
            steps {
                git branch: 'test', url: 'https://github.com/kolab-web/terraform-aws-lex-examples'
            }
        }
        stage('Initializing Terraform') {
            steps {
                script {
                    dir('book-trip') {
                        sh 'terraform init'
                    }
                }
            }
        }
        stage('Validating Terraform') {
            steps {
                script {
                    dir('book-trip') {
                        sh 'terraform validate'
                    }
                }
            }
        }
        stage('Terraform Version') {
            steps {
                script {
                    dir('book-trip') {
                        sh 'terraform --version'
                    }
                }
            }
        }
        stage('TRIVY FS SCAN') {
            steps {
                script{
                    dir('book-trip'){
                        sh "trivy fs . > trivyfs.txt"
                    }
                }
            }
        }
        // stage('OWASP Dependency Check') {
        //     steps {
        //         dependencyCheck additionalArguments: '--scan ./', odcInstallation: 'DP-Check'
        //         dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
        //     }
        // }
        stage('Snyk Test') {
            steps {
                script {
                    withCredentials([string(credentialsId: 'snyk', variable: 'SNYK_TOKEN')]) {
                        sh 'snyk code test || true'
                        sh 'echo Snyk Test Completed'
                    }
                }
            }
        }
        stage('Terraform Plan') {
            steps {
                script {
                    dir('book-trip') {
                        sh 'terraform plan'
                    }
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    dir('book-trip') {
                        sh 'terraform apply --auto-approve'
                    }
                }
            }
        }
    }
}