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

        stage('Check for Docker Image Changes') {
            steps {
                script {
                    def dockerChanged = false

                    // Check if Dockerfile or any file relevant to the Docker image has changed
                    def dockerFiles = ['Dockerfile', 'path/to/related/files/*'] // Add more files/folders here if needed
                    dockerFiles.each { file ->
                        if (isChanged(file)) {
                            dockerChanged = true
                        }
                    }

                    if (dockerChanged) {
                        echo "Docker-related files have changed, rebuilding Docker image..."
                        // Rebuild the Docker image only if the Docker-related files have changed
                        bat "docker build -t ${IMAGE}:${VERSION} ."
                    } else {
                        echo "No changes detected in Docker-related files. Skipping image rebuild."
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    // Run tests based on whether the TAGS parameter is set
                    if (params.TAGS) {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --dryrun --outputdir /app/output/dryrun --include ${params.TAGS} /app"
                        """
                    } else {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --dryrun --outputdir /app/output/dryrun /app"
                        """
                    }
                }
            }
        }

        stage('Archive Logs') {
            steps {
                script {
                    echo "Archiving test logs..."
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'Logs/**/*.log', fingerprint: true
                }
            }
        }
    }

    post {
        always {
            script {
                def outputDir = 'output/dryrun'

                echo "Saving HTML and XML test results..."

                // Archive XML and HTML files generated by Robot Framework tests
                if (fileExists("${outputDir}/output.xml")) {
                    archiveArtifacts artifacts: "${outputDir}/output.xml", allowEmptyArchive: true
                }
                if (fileExists("${outputDir}/report.html")) {
                    archiveArtifacts artifacts: "${outputDir}/report.html", allowEmptyArchive: true
                }
                if (fileExists("${outputDir}/log.html")) {
                    archiveArtifacts artifacts: "${outputDir}/log.html", allowEmptyArchive: true
                }

                // Use the HTML Publisher Plugin to display the test results
                publishHTML(target: [
                    reportName: 'Robot Framework Test Report',
                    reportDir: "${outputDir}",
                    reportFiles: 'report.html',
                    keepAll: true
                ])
            }
        }
    }

    triggers {
        cron("${params.BUILD_TIME ?: 'H 2 * * 1-5'}")
    }
}

// Helper function to check if a file has changed
def isChanged(file) {
    // Implement logic to check if the file has changed. 
    // For example, you could use Git commands to check if a file has been modified since the last commit.
    def gitStatus = bat(script: "git diff --name-only HEAD~1..HEAD -- ${file}", returnStdout: true).trim()
    return gitStatus.contains(file)
}
