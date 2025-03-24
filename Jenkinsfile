pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        // Adjust paths to match Docker container paths
        EXAM_TESTS_DIR = 'C:\\ProgramData\\Jenkins\\.jenkins\\workspace\\ExamTests\\ExamTests'
        LOGS_DIR = "${EXAM_TESTS_DIR}\\Logs"
    }

    stages {
        stage('Verify Docker') {
            steps {
                script {
                    echo "Verifying Docker installation on the Jenkins node..."
                    // For Windows agents, use 'bat' instead of 'sh'
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
                    // Check Docker version
                    echo "Building Docker image..."
                    bat 'docker build -t robotframework-test .'  // Use 'bat' for Windows agents
                }
            }
        }

        stage('Run Tests') {
    steps {
        script {
            echo "Running tests with tags: ${params.TAGS}"

            // Convert EXAM_TESTS_DIR to Docker-compatible path (Unix-style)
            def examTestsDirDocker = EXAM_TESTS_DIR.replaceAll("\\\\", "/") // Convert Windows backslashes to forward slashes

            // Ensure drive letter format for Docker (handle C: drive)
            examTestsDirDocker = "C:/${examTestsDirDocker.substring(2)}" // Remove 'C:' and prepend with Docker's C:/ format

            // Construct the Docker command to run Robot Framework tests
            def command = "docker run --rm -v ${examTestsDirDocker}:${examTestsDirDocker} robotframework-test --tags ${params.TAGS} ${examTestsDirDocker}/TestCases"

            echo "Running command: ${command}"

            // Run the command and capture the output
            def result = bat(script: command, returnStdout: true).trim()  // Use 'bat' for Windows agents

            // Save the output to the logs directory (using the defined LOGS_DIR)
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
