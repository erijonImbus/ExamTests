pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        // Adjust paths to match Docker container paths
        EXAM_TESTS_DIR = '/usr/src/app/ExamTests'
        LOGS_DIR = "${EXAM_TESTS_DIR}/Logs"
    }

    stages {
        stage('Verify Docker') {
            steps {
                script {
                    echo "Verifying Docker installation on the Jenkins node..."
                    // Verify Docker installation and show version (Linux example)
                    sh 'docker --version'  // Use `bat 'docker --version'` for Windows-based Jenkins agent
                }
            }
        }

        stage('Prepare') {
            steps {
                script {
                    if (fileExists(LOGS_DIR)) {
                        deleteDir()  // Remove existing logs
                    }
                    echo "Preparing the environment..."
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Check Docker version
                    echo "Building Docker image..."
                    sh 'docker build -t robotframework-test .'  // Use `bat` for Windows agents
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    // Construct the docker command to run Robot Framework tests
                    def command = "docker run --rm -v ${EXAM_TESTS_DIR}:${EXAM_TESTS_DIR} robotframework-test --tags ${params.TAGS} ${EXAM_TESTS_DIR}/TestCases"
                    echo "Running command: ${command}"

                    // Run the command and capture the output
                    def result = sh(script: command, returnStdout: true).trim()  // `sh` for Linux, `bat` for Windows agents

                    // Save the output to the logs directory
                    writeFile file: "${LOGS_DIR}/robot_output.log", text: result
                    echo "Test results saved to ${LOGS_DIR}/robot_output.log"
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
