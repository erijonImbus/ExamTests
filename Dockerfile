FROM python:3.9-slim

# Switch to root user to install dependencies
USER root

# Install required packages (Python, pip, Robot Framework, and other dependencies)
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    && pip3 install --upgrade pip \
    && pip3 install robotframework \
    && apt-get clean

# Install Java (Jenkins requires it)
RUN apt-get install -y openjdk-11-jdk

WORKDIR C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests

# Set environment variable for logs and test directory
ENV EXAM_TESTS_DIR=C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests\TestCases
ENV LOGS_DIR=C:\Users\erijon.IMBUS\Desktop\RBF-MATERIALS\Exam-Copy\ExamTests\Logs

# Expose port (optional, if needed for Jenkins to interact with Docker container)
EXPOSE 8080

# Command to run Robot Framework tests (to be overridden in Jenkinsfile)
ENTRYPOINT ["robot"]

# Default command (this can be overridden in Jenkins pipeline)
CMD ["--help"]
