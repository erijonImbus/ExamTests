FROM python:3.11-slim

# Set environment variables to avoid Python buffering and for easier troubleshooting
ENV PYTHONUNBUFFERED=1
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Selenium, Chrome, and ChromeDriver
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    ca-certificates \
    unzip \
    libx11-dev \
    libxcomposite-dev \
    libxrandr-dev \
    libgtk-3-0 \
    libgbm-dev \
    libnss3 \
    libasound2 \
    libappindicator3-1 \
    libxtst6 \
    libxss1 \
    libgdk-pixbuf2.0-0 \
    libsecret-1-0 \
    libvulkan1 \
    xdg-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stable version
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Set the working directory
WORKDIR /app

# Copy your requirements.txt file to the container
COPY python_requirements.txt .

# Install Python dependencies from the requirements file
RUN pip install --no-cache-dir -r python_requirements.txt
