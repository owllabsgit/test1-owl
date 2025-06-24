pipeline {
    agent any

    environment {
        GIT_REPO = 'https://github.com/louayparadigma/test1-owl.git'
        DOCKER_IMAGE = 'medlouay/symfony-apptest1:latest'
        DEPLOYMENT = 'symfony-deployment'
        CONTAINER = 'symfony-apptest1'
        NAMESPACE = 'default'
    }

    stages {
        stage('Clone or Update Repository') {
            steps {
                script {
                    if (fileExists('test1-owl')) {
                        echo 'Repository already exists, pulling latest changes'
                        dir('test1-owl') {
                            sh 'git fetch && git pull origin main'
                        }
                    } else {
                        echo 'Cloning the project'
                        withCredentials([string(credentialsId: '10', variable: 'GITHUB_TOKEN')]) {
                            sh '''
                                git clone -b main https://${GITHUB_TOKEN}@github.com/louayparadigma/test1-owl.git
                            '''
                        }
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker Image'
                dir('test1-owl/FirstProject') {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                echo 'Pushing Docker Image to Docker Hub'
                withCredentials([usernamePassword(credentialsId: '20', usernameVariable: 'DOCKER_USERNAME', passwordVariable: 'DOCKER_PASSWORD')]) {
                    sh '''
                        echo $DOCKER_PASSWORD | docker login -u $DOCKER_USERNAME --password-stdin
                        docker push ${DOCKER_IMAGE}
                    '''
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                dir('pfetest/test1-owl/FirstProject') {
                    sh '''
                        kubectl apply -f /root/pfetest/test1-owl/FirstProject/symfony-deployment.yaml
                        kubectl rollout restart deployment symfony-app
                    '''
                }
            }
        }

        stage('Health Check') {
            steps {
                sh 'kubectl get pods -o wide'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully.'
        }
        failure {
            echo '❌ Pipeline failed.'
        }
    }
}
