pipeline {
    agent any  // Use any available agent (you can change this to a specific agent if needed)

    environment {
        // Set the Docker image name
        DOCKER_IMAGE = 'robot-framework-tests'
        RESULTS_DIR = 'C://Users//erijon.IMBUS//Desktop//RBF-MATERIALS//Exam - Copy//ExamTests//Logs'
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the code from your Git repository
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build the Docker image for running the Robot Framework tests
                    echo "Building Docker image: ${DOCKER_IMAGE}"
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                }
            }
        }

        stage('Run Tests in Docker') {
            steps {
                script {
                    // Run the Docker container with Robot Framework
                    echo "Running Robot Framework tests inside Docker container"
                    sh """
                    docker run --rm -v \$(pwd):/app ${DOCKER_IMAGE}
                    """
                }
            }
        }

        stage('Publish Results') {
            steps {
                script {
                    // Archive the test results directory
                    echo "Archiving test results"
                    archiveArtifacts allowEmptyArchive: true, artifacts: "${RESULTS_DIR}/**", onlyIfSuccessful: true
                }
            }
        }

        stage('Publish HTML Report') {
            steps {
                script {
                    // Optionally, you can publish the test report (HTML) to Jenkins UI
                    echo "Publishing HTML report"
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: true, keepAll: true, reportDir: "${RESULTS_DIR}", reportFiles: 'log.html', reportName: 'Robot Framework Test Report'])
                }
            }
        }
    }

    post {
        always {
            // Clean up resources or Docker images after the pipeline
            echo 'Cleaning up Docker images'
            sh 'docker rmi ${DOCKER_IMAGE}'
        }
        success {
            echo 'Test run completed successfully'
        }
        failure {
            echo 'Test run failed'
        }
    }
}
