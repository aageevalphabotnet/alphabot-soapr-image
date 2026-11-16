pipeline 
{
    agent any
    
    environment {
        // GitHub repository URL
        // Environment variables for the build
        DOCKER_IMAGE_NAME = 'alphabot-restapi'
        DOCKER_REGISTRY = 'aliaksei1'
    }
    
    options {
        // Keep last 10 builds
        buildDiscarder(logRotator(numToKeepStr: '10'))
        // Add timeout (optional)
        timeout(time: 20, unit: 'MINUTES')
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build Image') {
            steps {
                script 
                {
                    // Authenticate with Docker Hub
                    withDockerRegistry(credentialsId: 'build-deploy-to-dochub-credentials', url: 'https://index.docker.io/v1/') 
                    {
                        sh './build_image.sh'
                    }
                }
            }
        }
    }
    
    post {
        always {
            // Cleanup Docker resources
            script {
                sh 'docker system prune -af || true'
            }
        }
        failure {
            // Send notification on failure
            echo "Build failed! Notify team..."
        }
        success {
            echo "Build succeeded!"
        }
    }
} //pipeline
