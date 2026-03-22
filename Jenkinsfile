pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = 'ANKITA_DOCK_HUB'
        DOCKER_IMAGE = 'ankitanallamilli/hotstar-webapp'
        IMAGE_TAG = "${BUILD_NUMBER}"
    }

    tools {
        maven 'Maven'
        jdk 'JDK17'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/2000ankitareddy/Hotstar_Project.git', branch: 'main'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean package'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("${DOCKER_IMAGE}:${IMAGE_TAG}")
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', "${DOCKER_HUB_CREDENTIALS}") {
                        docker.image("${DOCKER_IMAGE}:${IMAGE_TAG}").push()
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    sh "sed -i 's|IMAGE_TAG|${IMAGE_TAG}|g' k8s/deployment.yml"
                    sh 'kubectl apply -f k8s/deployment.yml'
                    sh 'kubectl apply -f k8s/service.yml'
                }
            }
        }
    }
}
