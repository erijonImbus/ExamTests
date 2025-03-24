pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        EXAM_TESTS_DIR = 'C:/ProgramData/Jenkins/.jenkins/workspace/ExamTests'
        LOGS_DIR = "${EXAM_TESTS_DIR}/Logs"
    }

    stages {
        stage('Verify Docker') {
            steps {
                script {
                    echo "Verifying Docker installation on the Jenkins node..."
                    bat 'docker --version'
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
                    echo "Building Docker image..."
                    bat 'docker build -t robotframework-test .'  // Use 'bat' for Windows agents
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    // Use the already built Docker image and adjust the volume mounting format
                    def testCasesDirDocker = "C:/ProgramData/Jenkins/.jenkins/workspace/ExamTests/TestCases"
                    
                    // Convert the Windows path to Docker's expected format
                    def testCasesDirDockerFormatted = testCasesDirDocker.replace("C:/", "//c/")

                    // Start building the Docker command
                    def command = "docker run --rm -v ${testCasesDirDockerFormatted}:/usr/src/app/ExamTests/TestCases robotframework-test:latest"

                    // Only append --tags if TAGS is provided
                    if (params.TAGS?.trim()) {
                        command += " --tags ${params.TAGS}"
                    }

                    // Add the test case directory to the command
                    command += " /usr/src/app/ExamTests/TestCases"

                    echo "Running command: ${command}"

                    // Run the command and capture the output
                    def result = bat(script: command, returnStdout: true).trim()

                    // Save the output to the logs directory
                    writeFile file: "${LOGS_DIR}\\robot_output.log", text: result
                    echo "Test results saved to ${LOGS_DIR}\\robot_output.log"
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
