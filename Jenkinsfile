pipeline {
    agent any

    parameters {
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
        string(name: 'BUILD_TIME', defaultValue: 'H 2 * * 1-5', description: 'Cron schedule to trigger the build periodically (default: H 2 * * 1-5)')
    }

    environment {
        EXAM_TESTS_DIR = 'C:/Users/erijon.IMBUS/Desktop/RBF-MATERIALS/Exam - Copy/ExamTests'  // Correct path format for Windows
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

                    // Find all .robot files in the provided directory using the corrected path format
                    def robotFiles = findFiles(glob: "${EXAM_TESTS_DIR}/Test Cases/**/*.robot")

                    if (robotFiles) {
                        // Loop through each .robot file and run tests
                        robotFiles.each { robotFile ->
                            echo "Checking tags in file: ${robotFile.name}"

                            // Command to check if the file contains the specified tag
                            def tagCheckCommand = """robot --dryrun --listtags "${robotFile.name}""""
                            
                            // Run the dry run to list tags
                            def tagsOutput = bat(script: tagCheckCommand, returnStdout: true).trim()

                            // Check if the desired tag exists in the file's tags list
                            if (tagsOutput.contains(params.TAGS)) {
                                echo "Running tests on ${robotFile.name} with tag: ${params.TAGS}"
                                
                                // Run the actual robot tests with the specified tag
                                bat """
                                    robot "${robotFile.name}" --tags ${params.TAGS} > "${LOGS_DIR}/test_${robotFile.name}.log"
                                """
                            } else {
                                echo "Tag '${params.TAGS}' not found in ${robotFile.name}. Skipping file."
                            }
                        }
                    } else {
                        echo "No .robot files found in ${EXAM_TESTS_DIR}/Test Cases."
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