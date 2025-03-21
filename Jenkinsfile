pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        EXAM_TESTS_DIR = 'C:/Users/erijon.IMBUS/Desktop/RBF-MATERIALS/Exam-Copy/ExamTests'
        LOGS_DIR = "${EXAM_TESTS_DIR}/Logs"  
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    if (fileExists(LOGS_DIR)) {
                        deleteDir()  
                    }
                    echo "Preparing the environment..."
                }
            }
        }

        stage('Build Docker Image') {
    steps {
        script {

            bat 'docker --version'

            echo "Building Docker image..."
            bat 'docker build -t robotframework-test .'

        }
    }
}

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    def command = "docker run --rm -v ${EXAM_TESTS_DIR}:/usr/src/app/test_cases robotframework-test --tags ${params.TAGS} /usr/src/app/test_cases"
                    echo "Running command: ${command}"

                    def result = bat(script: command, returnStdout: true).trim()

                    writeFile file: "${LOGS_DIR}/robot_output.log", text: result
                    echo "Test results saved to ${LOGS_DIR}/robot_output.log"
                }
            }
        }

        stage('Archive Results') {
            steps {
                script {
                    echo "Archiving test results..."
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'Logs/**/*.log', fingerprint: true
                }
            }
        }
    }

    triggers {
        cron("${params.BUILD_TIME ?: 'H * * * 1-5'}")
    }
}
