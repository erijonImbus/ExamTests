# Use an official Python image as the base image
FROM python:3.9-slim

# Set environment variables to ensure the output isn't buffered and to avoid interactive prompts
ENV PYTHONUNBUFFERED=1
ENV DEBIAN_FRONTEND=noninteractive

# Set the working directory inside the container
WORKDIR /app  # Container working directory, use Linux-style path

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Install Robot Framework and dependencies (base)
RUN pip install --no-cache-dir robotframework

# Install additional Robot Framework libraries if required
RUN pip install --no-cache-dir robotframework-seleniumlibrary

# Copy your test cases and resources (path relative to the Docker context)
COPY ./ExamTests /app/ExamTests  

# Command to run Robot Framework tests (adjust this if you have specific command-line args or need to run specific tests)
CMD ["robot", "--outputdir", "results", "--log", "results/log.html", "--report", "results/report.html", "tests/"]
