pipeline {
    agent any

    tools {
        maven "Maven"
        jdk "JDK17"
    }

    environment {
        DOCKER_HUB_USERNAME = "ankitanallamilli"
        IMAGE_NAME = "${DOCKER_HUB_USERNAME}/hotstar-image:${BUILD_NUMBER}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scmGit(
                    branches: [[name: '*/main']],
                    userRemoteConfigs: [[
                        credentialsId: 'ankigithub',
                        url: 'https://github.com/2000ankitareddy/Hotstar_Project.git'
                    ]]
                )
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME .'
            }
        }

        stage('Login to DockerHub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'USERNAME',
                    passwordVariable: 'PASSWORD'
                )]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                sh 'docker push $IMAGE_NAME'
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                sed -i "s|IMAGE_TAG|${BUILD_NUMBER}|g" deployment.yml
                kubectl apply -f deployment.yml
                kubectl apply -f service.yml
                '''
            }
        }
    }
}
