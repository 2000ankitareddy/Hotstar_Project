pipeline {
    agent any

    environment {
        WORK_DIR = "/var/lib/jenkins/workspace/Hotstar_WebApp"
        IMAGE_NAME = "hotstar-webapp"
        IMAGE_TAG = "${BUILD_NUMBER}"
        CONTAINER_NAME = "hotstar-webapp-container"
        PORT = "8080"
        DOCKERHUB_USER = "ankitanallamilli"
        DOCKER_CREDS = "ANKITA_DOCK_HUB"
        CONTAINER_PORT = "8080"
        AWS_REGION = "us-east-1"
        EKS_CLUSTER = "saicluster"
        KUBECONFIG = "/var/lib/jenkins/.kube/config"
    }

    stages {
        stage('Checkout Code') {
            steps {
                dir("${WORK_DIR}") {
                    git branch: 'main', url: 'https://github.com/2000ankitareddy/Hotstar_Project.git'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${WORK_DIR}") {
                    sh '''
                        docker rmi -f ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true
                        docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                    '''
                }
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: "${DOCKER_CREDS}",
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh """
                        echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh "docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}"
            }
        }

        stage('Update K8s Deployment') {
            steps {
                sh '''
                    sed -i "s|image:.*|image: ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}|" k8s/deploy1.yml
                '''
            }
        }

        stage('Configure EKS Access') {
            steps {
                sh '''
                    export PATH=$PATH:/usr/local/bin
                    aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER
                    /usr/local/bin/kubectl config current-context
                '''
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    kubectl apply -f k8s/deploy1.yml
                    kubectl apply -f k8s/ingress1.yml
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                sh '''
                    kubectl rollout status deployment hotstarwebapp-deployment
                    kubectl get pods -o wide
                    kubectl get svc
                    kubectl get ingress
                '''
            }
        }
    }
}
