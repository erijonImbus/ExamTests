# Use official Jenkins image as the base
FROM jenkins/jenkins:lts

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

# Switch back to Jenkins user
USER jenkins

# Set environment variables for Robot Framework logging
ENV ROBOT_OUTPUT_DIR=/var/jenkins_home/robot_output

# Expose the Jenkins port
EXPOSE 8080

# Set default Jenkins home directory
VOLUME /var/jenkins_home
