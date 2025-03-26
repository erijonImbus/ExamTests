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
                    def dockerFiles = ['Dockerfile', 'python_requirements.txt']
                    dockerFiles.each { file ->
                        def gitDiff = bat(script: "git diff --name-only HEAD~1..HEAD -- ${file}", returnStdout: true).trim()
                        if (gitDiff) {
                            dockerFilesChanged = true
                        }
                    }

                    if (dockerFilesChanged) {
                        echo "Docker-related files have changed, rebuilding Docker image..."
                        bat "docker build -t ${IMAGE}:${VERSION} ."
                    } else {
                        echo "No changes detected in Docker-related files. Skipping Docker image build."
                    }
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    if (params.TAGS) {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --loglevel DEBUG --outputdir /app/output --include ${params.TAGS} /app"
                        """
                    } else {
                        bat """
                        docker run --rm -v %WORKSPACE%:/app ${IMAGE}:${VERSION} bash -c "robot --loglevel DEBUG --outputdir /app/output /app"
                        """
                    }
                }
            }
        }

        stage('Archive Logs') {
            steps {
                script {
                    echo "Archiving test logs..."
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'output/**/*.log', fingerprint: true
                }
            }
        }
    }

    post {
        always {
            script {
                def outputDir = 'output'
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
                    reportDir: "${WORKSPACE}/output",  // Adjust this path if necessary
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
