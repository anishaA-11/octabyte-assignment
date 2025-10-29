pipeline {
    agent any

    environment {
        IMAGE_NAME = "octabyte-flask-app"
        DOCKERHUB_USER = "anishaa1110"   // 🔹 Replace this
        DOCKER_TAG = "latest"
    }

    triggers {
        githubPush()   // 🔹 Automatically triggers on PRs or pushes from GitHub webhook
    }

    stages {
        stage('Checkout') {
            steps {
                echo '📦 Cloning repository...'
                git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/anishaA-11/octabyte-assignment.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                dir('app') {
                    echo '📦 Installing Python dependencies...'
                    bat 'pip install -r requirements.txt || exit /b 0'
                }
            }
        }

        stage('Unit Tests') {
            steps {
                dir('app') {
                    echo '🧪 Running unit tests...'
                    bat 'pytest -q tests/unit || exit /b 0'
                }
            }
        }

        stage('Integration Tests') {
            steps {
                dir('app') {
                    echo '🔗 Running integration tests...'
                    bat 'pytest -q tests/integration || exit /b 0'
                }
            }
        }

        stage('Dependency Security Scan') {
            steps {
                dir('app') {
                    echo '🔍 Scanning Python dependencies...'
                    bat '''
                    pip install pip-audit || exit /b 0
                    pip-audit || exit /b 0
                    '''
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('app') {
                    echo '🐳 Building Docker image...'
                    bat 'docker build -t %IMAGE_NAME%:%DOCKER_TAG% . || exit /b 0'
                }
            }
        }

        stage('Container Vulnerability Scan') {
            steps {
                echo '🔍 Scanning Docker image with Trivy...'
                bat '''
                trivy --version || choco install trivy -y
                trivy image %IMAGE_NAME%:%DOCKER_TAG% || exit /b 0
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo '📤 Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    bat '''
                    echo %DOCKER_PASS% | docker login -u %DOCKER_USER% --password-stdin
                    docker tag %IMAGE_NAME%:%DOCKER_TAG% %DOCKER_USER%/%IMAGE_NAME%:%DOCKER_TAG%
                    docker push %DOCKER_USER%/%IMAGE_NAME%:%DOCKER_TAG%
                    docker logout
                    '''
                }
            }
        }

        stage('Deploy to Staging') {
            steps {
                echo '🚀 Deploying to Staging environment...'
                bat '''
                docker rm -f octabyte-staging || exit /b 0
                docker run -d -p 5001:5000 --name octabyte-staging %DOCKERHUB_USER%/%IMAGE_NAME%:%DOCKER_TAG%
                '''
            }
        }

        stage('Manual Approval') {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: '✅ Approve deployment to Production?', ok: 'Deploy'
                }
            }
        }

        stage('Deploy to Production') {
            steps {
                echo '🚀 Deploying to Production environment...'
                bat '''
                docker rm -f octabyte-prod || exit /b 0
                docker run -d -p 80:5000 --name octabyte-prod %DOCKERHUB_USER%/%IMAGE_NAME%:%DOCKER_TAG%
                '''
            }
        }
    }

    post {
        always {
            echo '🧹 Cleaning up containers...'
            bat '''
            for /f "tokens=*" %%i in ('docker ps -q --filter "ancestor=%IMAGE_NAME%:%DOCKER_TAG%"') do docker stop %%i
            exit /b 0
            '''
        }
        success {
            echo '✅ Build and deployment successful!'
            emailext(
                to: 'your_email@example.com',
                subject: "✅ SUCCESS: Jenkins Pipeline - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Good news 🎉</p>
                         <p>Your Jenkins pipeline <b>${env.JOB_NAME}</b> completed successfully.</p>
                         <p>Docker image pushed: <b>${env.DOCKERHUB_USER}/${env.IMAGE_NAME}:${env.DOCKER_TAG}</b></p>
                         <p><a href="${env.BUILD_URL}">View build logs</a></p>""",
                mimeType: 'text/html'
            )
        }
        failure {
            echo '❌ Build failed!'
            emailext(
                to: 'your_email@example.com',
                subject: "❌ FAILURE: Jenkins Pipeline - ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Uh oh 😢</p>
                         <p>Your Jenkins pipeline <b>${env.JOB_NAME}</b> failed.</p>
                         <p><a href="${env.BUILD_URL}">View logs here</a></p>""",
                mimeType: 'text/html'
            )
        }
    }
}
