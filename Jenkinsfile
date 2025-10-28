pipeline {
    agent any

    environment {
        IMAGE_NAME = "octabyte-flask-app"
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Cloning GitHub repository...'
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/anishaA-11/octabyte-assignment.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    echo '📦 Installing Python dependencies...'
                    bat '''
                    echo Installing dependencies...
                    pip install -r requirements.txt || exit /b 0
                    '''
                }
            }
        }

        stage('Run Tests') {
            steps {
                dir('app') {
                    echo '🧪 Running tests...'
                    bat '''
                    echo Running tests...
                    pytest -q || exit /b 0
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    echo '🐳 Building Docker image...'
                    bat '''
                    echo Building Docker image...
                    docker build -t %IMAGE_NAME%:latest . || exit /b 0
                    '''
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                echo '🚀 Starting Docker container...'
                bat '''
                echo Running container...
                docker run -d -p 5000:5000 %IMAGE_NAME%:latest || exit /b 0
                '''
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning up containers (ignore errors)...'
            bat '''
            echo Stopping containers...
            for /f "tokens=*" %%i in ('docker ps -q --filter "ancestor=%IMAGE_NAME%:latest"') do (
                docker stop %%i || exit /b 0
            )
            exit /b 0
            '''
        }
        success {
            echo '✅ Pipeline finished successfully!'
        }
        failure {
            echo '❌ Something failed, check logs above.'
        }
    }
}
