pipeline {
    agent any
    
    environment {
        // Define environment variables if needed
        IMAGE_NAME = 'backend-app'
        IMAGE_TAG = "${env.BUILD_NUMBER}"
        CONTAINER_NAME = 'laravel-app'
    }

    stages {
        stage('Build') {
            steps {
                // Clone the Git repository
                git 'https://github.com/massamba123/filament.git'
                
                // Install Composer dependencies
                sh 'composer install'
                
                // Copy the environment file
                sh 'cp .env.example .env'
                
                // Generate Laravel application key
                sh 'php artisan key:generate'
                
                //sh "sed -i -e 's/DB_DATABASE=laravel/DB_DATABASE=laravel/g' .env"
                sh "php artisan migrate"
            }
        }

        stage('Test') {
            steps {
                // Run PHPUnit tests
                sh './vendor/bin/phpunit'
            }
        }
        
         stage('Stop and Remove Docker Container') {
            steps {
                script {
                    // Stop and remove the running Docker container
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                }
            }
        }

        stage('Cleanup') {
            steps {
                // Clean up unused Docker images and containers
                sh 'docker system prune -af'
            }
        }
                stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                  
                    // Push Docker image to registry (if needed)
                    // sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Run Docker Container') {
            steps {
                script {
                    // Run Docker container
                    sh "docker run -d --name ${CONTAINER_NAME} -p 8181:8181 ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
    }
}
