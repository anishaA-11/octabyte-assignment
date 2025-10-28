pipeline {
    agent any

    environment {
        IMAGE_NAME = "octabyte-flask-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Cloning GitHub repository...'
                git branch: 'main',
                    credentialsId: 'github-creds',
                    url: 'https://github.com/anishaA-11/octabyte-assignment.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    echo 'Installing Python dependencies...'
                    sh 'pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('app') {
                    echo 'Running unit tests...'
                    sh 'pytest -q || true'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    echo 'Building Docker image...'
                    sh 'docker build -t ${IMAGE_NAME}:latest .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Starting Docker container...'
                sh 'docker run -d -p 5000:5000 ${IMAGE_NAME}:latest'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up running containers...'
            sh 'docker ps -q --filter "ancestor=${IMAGE_NAME}:latest" | xargs -r docker stop || true'
        }
    }
}
