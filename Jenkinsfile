pipeline {
    agent any

    stages {
        stage('List Files') {
            steps {
                echo '📁 Listing files in workspace...'
                sh 'ls -l'
            }
        }

        stage('Start Postgres') {
            steps {
                echo '🏗️ Starting Postgres containers...'
                sh 'docker compose up -d'
            }
        }

        stage('Wait for Postgres') {
            steps {
                echo '⏳ Waiting 1 minute for Postgres to initialize...'
                sleep time: 1, unit: 'MINUTES'
            }
        }

        stage('Run Flyway Migrations') {
            steps {
                echo '🚀 Running Flyway migrations...'
                sh 'docker compose -f docker-compose.flyway.yml up --abort-on-container-exit'
            }
        }
        stage('Wait for migrations') {
                    steps {
                        echo '⏳ Waiting 1 minute for Postgres to initialize...'
                        sleep time: 1, unit: 'MINUTES'
                    }
                }

        stage('Truncate Databases') {
            steps {
                echo '🧹 Truncating databases...'
                sh '''
                    chmod +x truncate_postgres_in_docker.sh
                    ./truncate_postgres_in_docker.sh
                '''
            }
        }

        stage('Wait for Cleanup') {
            steps {
                echo '⏳ Waiting 2 minutes after truncation...'
                sleep time: 2, unit: 'MINUTES'
            }
        }

        stage('Shutdown Services') {
            steps {
                echo '🛑 Stopping and cleaning up containers...'
                sh 'docker compose down'
            }
        }
    }

    post {
        always {
            echo '✅ Pipeline finished.'
        }
    }
}
