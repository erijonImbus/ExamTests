pipeline {
    agent any

    parameters {
        // Optional parameter to specify tags for filtering tests
        string(name: 'TAGS', defaultValue: '', description: 'Comma-separated tags to filter tests (leave empty to run all tests)')
    }

    environment {
        // Define the location of your ExamTests folder
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
                    // Determine the command to run tests, considering the provided tags
                    def tagFilter = params.TAGS ? "--tags ${params.TAGS}" : ""
                    echo "Running tests with tags: ${params.TAGS}"

                    // Loop through all test files in TestCases directory and execute them
                    def testFiles = findFiles(glob: "${EXAM_TESTS_DIR}/TestCases/**/*.resource")
                    testFiles.each { testFile ->
                        // Run the test file with specified tags
                        echo "Executing test file: ${testFile.name}"
                        sh """
                            # Command to execute tests, assuming a hypothetical test runner (e.g., Maven, Gradle, etc.)
                            test-runner --test ${testFile.name} ${tagFilter} > ${LOGS_DIR}/test_${testFile.name}.log
                        """
                    }
                }
            }
        }

        stage('Archive Results') {
            steps {
                script {
                    // Archive the test results logs in the Logs folder
                    echo "Archiving test results..."
                    archiveArtifacts allowEmptyArchive: true, artifacts: 'Logs/**/*.log', fingerprint: true
                }
            }
        }
    }

    // Periodic build trigger - configure the Jenkins job to build periodically (this will go in Jenkins job configuration, not in Jenkinsfile)
    triggers {
        cron('H 2 * * 1-5')  // Example: This cron syntax will schedule the build to run every weekday at 2 AM
    }
}
