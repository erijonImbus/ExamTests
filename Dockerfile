# Use an official Python image as the base image
FROM python:3.9-slim

# Set environment variables to ensure the output isn't buffered and to avoid interactive prompts
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory inside the container
WORKDIR C:/Users/erijon.IMBUS/Desktop/RBF-MATERIALS/Exam - Copy/ExamTests/

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Robot Framework and dependencies (this will be the base)
RUN pip install --no-cache-dir robotframework

# Install additional Robot Framework libraries if required (you can add more as needed)
RUN pip install --no-cache-dir robotframework-seleniumlibrary

# Copy your test cases and resources (make sure your files are in the same directory as the Dockerfile)
COPY C:/Users/erijon.IMBUS/Desktop/RBF-MATERIALS/Exam - Copy/ExamTests/

# Optionally, install any necessary system dependencies
# RUN apt-get update && apt-get install -y \
#     libssl-dev libffi-dev python3-dev build-essential

# Command to run Robot Framework tests (adjust this if you have specific command-line args or need to run specific tests)
CMD ["robot", "--outputdir", "results", "--log", "results/log.html", "--report", "results/report.html", "tests/"]
