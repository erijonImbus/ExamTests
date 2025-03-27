pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
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
                    def dockerFilesChanged = false
                    
                    // List of files that impact Docker build
                    def dockerFiles = ['Dockerfile', 'python_requirements.txt']
                    
                    // Check for changes in Docker-related files since the last commit
                    dockerFiles.each { file ->
                        def gitDiff = bat(script: "git diff --name-only HEAD~1..HEAD -- ${file}", returnStdout: true).trim()
                        if (gitDiff) {
                            dockerFilesChanged = true
                        }
                    }

                    // Rebuild the Docker image only if changes are detected
                    if (dockerFilesChanged) {
                        echo "Docker-related files have changed, rebuilding Docker image..."
                        bat "docker build -t ${IMAGE}:${VERSION} ."  // Rebuild the Docker image
                    } else {
                        echo "No changes detected in Docker-related files. Skipping Docker image build."
                    }
                }
            }
        }

        stage('Run Tests - Dryrun') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

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

                stage('Run Test Cases') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    if (params.TAGS) {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --outputdir /app/output/run -v BROWSER:headlesschrome --include ${params.TAGS} /app"
                        """
                    } else {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --outputdir /app/output/run -v BROWSER:headlesschrome /app"
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

                if (fileExists("${outputDir}/output.xml")) {
                    archiveArtifacts artifacts: "${outputDir}/output.xml", allowEmptyArchive: true
                }
                if (fileExists("${outputDir}/report.html")) {
                    archiveArtifacts artifacts: "${outputDir}/report.html", allowEmptyArchive: true
                }
                if (fileExists("${outputDir}/log.html")) {
                    archiveArtifacts artifacts: "${outputDir}/log.html", allowEmptyArchive: true
                }

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
