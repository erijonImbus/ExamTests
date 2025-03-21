pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        EXAM_TESTS_DIR = 'C:/Users/erijon.IMBUS/Desktop/RBF-MATERIALS/Exam - Copy/ExamTests'
        LOGS_DIR = "${EXAM_TESTS_DIR}/Logs"
    }

    stages {
        stage('Prepare') {
            steps {
                script {
                    // Clean up logs folder before running the tests
                    if (fileExists(LOGS_DIR)) {
                        deleteDir() // Clean up the Logs folder
                    }
                    echo "Preparing the environment..."
                }
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    echo "Running tests with tags: ${params.TAGS}"

                    // Correct the glob pattern to look for .robot files
                    def testFiles = findFiles(glob: "${EXAM_TESTS_DIR}/TestCases/**/*.robot")
                    
                    // Check if test files are found and then run tests
                    if (testFiles) {
                        testFiles.each { testFile ->
                            echo "Executing test file: ${testFile.name}"
                            // Run the tests using a batch command (for Windows)
                            bat """
                                robot ${testFile.name} --tags ${params.TAGS} > ${LOGS_DIR}\\test_${testFile.name}.log
                            """
                        }
                    } else {
                        echo "No test files found."
                    }
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
        cron("${params.BUILD_TIME ?: 'H 2 * * 1-5'}")
    }
}
