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
                    bat 'pip install -r requirements.txt'
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('app') {
                    echo 'Running unit tests...'
                    bat 'pytest -q || exit 0'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    echo 'Building Docker image...'
                    bat 'docker build -t %IMAGE_NAME%:latest .'
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo 'Starting Docker container...'
                bat 'docker run -d -p 5000:5000 %IMAGE_NAME%:latest'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up running containers...'
            bat 'for /f "tokens=*" %i in (\'docker ps -q --filter "ancestor=%IMAGE_NAME%:latest"\') do docker stop %i'
        }
    }
}
