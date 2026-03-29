pipeline {
    agent any

    environment {

        WORK_DIR = "/var/lib/jenkins/workspace/Hotstar_WebApp"

        IMAGE_NAME = "hotstar-webapp"
        IMAGE_TAG = "${BUILD_NUMBER}"

        DOCKERHUB_USER = "ankitanallamilli"
        DOCKER_CREDS = "ANKITA_DOCK_HUB"

        AWS_REGION = "us-east-1"
        EKS_CLUSTER = "saiicluster"

        DEPLOYMENT_FILE = "k8s/deploy1.yml"
        DEPLOYMENT_NAME = "hotstar-deployment"
        NAMESPACE = "default"

        EMAIL_ID = "ankitareddynallamilli@gmail.com"
    }


    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/ankitanallamilli/Hotstar_Project.git'
            }
        }


        stage('Build WAR File') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }


        stage('Build Docker Image') {
            steps {
                sh """
                sudo docker build \
                -t ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG} .
                """
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
                    echo \$DOCKER_PASS | sudo docker login \
                    -u \$DOCKER_USER --password-stdin
                    """
                }
            }
        }


        stage('Push Image to DockerHub') {
            steps {
                sh """
                sudo docker push \
                ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}
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
                sh """
                sed -i 's|image:.*|image: ${DOCKERHUB_USER}/${IMAGE_NAME}:${IMAGE_TAG}|' ${DEPLOYMENT_FILE}

                kubectl apply -f ${DEPLOYMENT_FILE}
                """
            }
        }


        stage('Verify Deployment Rollout') {
            steps {
                sh """
                kubectl rollout status deployment/${DEPLOYMENT_NAME} \
                -n ${NAMESPACE} \
                --timeout=120s
                """
            }
        }


        stage('Verify Pods and Services') {
            steps {
                sh """
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

            emailext(
                subject: "SUCCESS: Build #${BUILD_NUMBER}",
                body: """
Good news 🚀

Build Successful!

Job Name: ${JOB_NAME}
Build Number: ${BUILD_NUMBER}
Build URL: ${BUILD_URL}
""",
                to: "${EMAIL_ID}"
            )
        }


        failure {

            echo "Deployment Failed ❌ Attempting rollback..."

            sh """
            kubectl rollout undo deployment/${DEPLOYMENT_NAME} \
            -n ${NAMESPACE} || true
            """

            emailext(
                subject: "FAILED: Build #${BUILD_NUMBER}",
                body: """
Alert ❌

Build Failed!

Job Name: ${JOB_NAME}
Build Number: ${BUILD_NUMBER}
Build URL: ${BUILD_URL}

Rollback attempted automatically.
""",
                to: "${EMAIL_ID}"
            )
        }


        always {
            cleanWs()
        }
    }
}
