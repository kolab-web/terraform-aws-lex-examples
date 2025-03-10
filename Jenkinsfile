pipeline{
    agent any
    environment {
        AWS_ACCESS_KEY_ID = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION = 'eu-west-2'
    }
    tools{
        jdk 'jdk17'
        terraform 'terraform'
    }
    stages{
        
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('terraform'){
                         sh 'terraform init'
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform'){
                         sh 'terraform validate'
                    }
                }
            }
        }
        stage('checkout from Git'){
            steps{
                git branch: 'test', url: 'https://github.com/kolab-web/terraform-aws-lex-examples'
            }
        }
        stage('Terraform version'){
             steps{
                 sh 'echo $(pwd)'
                 sh 'cd book-trip'
                 sh 'echo $(pwd)'
                 sh 'terraform --version'
                }
        }         
        stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
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
                   // Run Snyk test
                   withCredentials([string(credentialsId: 'snyk', variable: 'SNYK_TOKEN')]) {
                       sh 'echo $(pwd)'
                       sh 'snyk code test||true'
                       sh 'echo Snyk Test Completed'
                   }
               }
           }
       }
        stage('Terraform init'){
            steps{
                sh 'terraform init'
            }
        }
        stage('Terraform plan'){
            steps{
                sh 'terraform plan'
            }
        }
        stage('Terraform apply'){
            steps{
                sh 'terraform {action} --auto approve'
            }
        }
    }
}