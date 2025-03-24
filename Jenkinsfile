pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        // Define Docker image and version variables
        IMAGE = "robotframework-docker-test"
        VERSION = "1.0"
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    echo "Preparing the environment..."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    bat "docker build -t ${IMAGE}:${VERSION} ."  // Build the Docker image with tag ${IMAGE}:${VERSION}
                }
            }
        }

  stage('Run Tests') {
    steps {
        script {
            echo "Running tests with tags: ${params.TAGS}"

            // Check if the TAGS parameter is set
            if (params.TAGS) {
                // If TAGS is set, run tests with the specified tags using --include
                bat """
                docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --dryrun --outputdir /app/output/dryrun --include ${params.TAGS} /app"
                """
            } else {
                // If TAGS is not set, run all tests
                bat """
                docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --dryrun --outputdir /app/output/dryrun /app"
                """
            }
        }
    }
}


        stage('Archive Results') {
            steps {
                script {
                    echo "Archiving test results..."
                    // Archive the logs for later inspection
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'Logs/**/*.log', fingerprint: true
                }
            }
        }
    }

    triggers {
        cron("${params.BUILD_TIME ?: 'H * * * 1-5'}")
    }
}
