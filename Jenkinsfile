pipeline {
    agent any

    environment {
        WORK_DIR = "/var/lib/jenkins/workspace/Hotstar_WebApp"

        IMAGE_NAME = "hotstar-webapp"
        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKERHUB_USER = "ankitanallamilli"
        DOCKER_CREDS = "ANKITA_DOCK_HUB"

        AWS_REGION = "us-east-1"
        EKS_CLUSTER = "saicluster"

        DEPLOYMENT_FILE = "k8s/deploy1.yml"
        DEPLOYMENT_NAME = "hotstar-deployment"
        NAMESPACE = "default"
    }

    stages {

        stage('Checkout Code') {
            steps {
                dir("${WORK_DIR}") {
                    git branch: 'main',
                    url: 'https://github.com/2000ankitareddy/Hotstar_Project.git'
                }
            }
        }

        stage('Build WAR File') {
            steps {
                dir("${WORK_DIR}") {
                    sh 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir("${WORK_DIR}") {
                    sh """
                    docker build -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                    """
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
                    echo \$DOCKER_PASS | docker login \
                    -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }

        stage('Push Image to DockerHub') {
            steps {
                sh """
                docker push ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
                """
            }
        }

        stage('Configure EKS Access') {
            steps {
                sh """
                aws eks update-kubeconfig \
                --region ${AWS_REGION} \
                --name ${EKS_CLUSTER}
                """
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                dir("${WORK_DIR}") {

                    sh """
                    sed -i 's|image:.*|image: ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}|' ${DEPLOYMENT_FILE}

                    kubectl apply -f ${DEPLOYMENT_FILE}
                    """
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                sh """
                kubectl rollout status deployment/${DEPLOYMENT_NAME} \
                -n ${NAMESPACE} \
                --timeout=120s

                kubectl get pods -o wide
                kubectl get svc
                kubectl get ingress
                """
            }
        }

    }

    post {

        success {
            echo "Deployment Successful 🚀"
        }

        failure {

            echo "Deployment Failed ❌ Attempting rollback..."

            sh """
            kubectl rollout undo deployment/${DEPLOYMENT_NAME} \
            -n ${NAMESPACE} || true
            """
        }

        always {
            cleanWs()
        }
    }
}
