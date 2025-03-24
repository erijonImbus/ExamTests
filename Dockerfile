FROM python:3.9-slim

# Switch to root user to install dependencies
USER root

# Install required packages (Python, pip, Robot Framework, and other dependencies)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    openjdk-11-jdk \
    && pip3 install --upgrade pip \
    && pip3 install robotframework \
    && apt-get clean

# Set the working directory inside the container (adjusting to your project structure)
WORKDIR /usr/src/app

# Expose port (optional, if needed for Jenkins to interact with Docker container)
EXPOSE 8080

# Set environment variables for paths (adjust to the Unix-style paths)
ENV EXAM_TESTS_DIR=/usr/src/app/ExamTests
ENV TEST_CASES_DIR=/usr/src/app/ExamTests/TestCases
ENV RESOURCES_DIR=/usr/src/app/ExamTests/Resources
ENV IMPORTS_DIR=/usr/src/app/ExamTests/Resources/Imports
ENV LOGS_DIR=/usr/src/app/ExamTests/Logs

# Command to run Robot Framework tests (this will be overridden in Jenkinsfile)
ENTRYPOINT ["robot"]

# Default command (this can be overridden in Jenkins pipeline)
CMD ["--help"]
