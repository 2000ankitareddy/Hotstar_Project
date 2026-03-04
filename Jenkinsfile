pipeline {
    agent any

    stages {

        stage('Checkout Code') {
            steps {
                checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[credentialsId: 'Sriramya', url: 'https://github.com/SriramyaGanni/Hotstar_Project.git']])
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t hotstar-image .'
            }
        }

        stage('Run Container') {
            steps {
                sh 'docker stop hotstar-container || true'
                sh 'docker rm hotstar-container || true'
                sh 'docker run -d -p 9090:8080 --name hotstar-container hotstar-image'
            }
        }
    }
}
