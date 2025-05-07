pipeline {
    agent any

    stages {
        stage('List Files') {
            steps {
                sh 'ls -l'
            }
        }

        stage('Docker Compose') {
            steps {
                echo '🏗️ Running docker compose'
                sh 'docker compose up -d'
                sh 'echo "Build successful"'
            }
        }

        stage('Wait for Services') {
            steps {
                echo '⏳ Waiting 2 minutes for services to become healthy...'
                sleep time: 2, unit: 'MINUTES'
            }
        }

        stage('Truncate Databases') {
            steps {
                sh '''
                    chmod +x truncate_postgres_in_docker.sh
                    ./truncate_postgres_in_docker.sh
                '''
            }
        }
        stage('Wait for Services') {
                    steps {
                        echo '⏳ Waiting 2 minutes for services to become healthy...'
                        sleep time: 2, unit: 'MINUTES'
                    }
                }
        stage('docker compose down'){
        steps{
        sh 'docker compose down'

        }}
    }

    post {
        always {
            echo '📦 Pipeline finished.'
        }
    }
}
