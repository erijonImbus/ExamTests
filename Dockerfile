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
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome (latest stable version)
RUN curl -sSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o google-chrome.deb \
    && apt-get update && apt-get install -y ./google-chrome.deb \
    && rm google-chrome.deb

# Install ChromeDriver by automatically matching it to the installed Google Chrome version
RUN google-chrome --version \
    && CHROME_VERSION=$(google-chrome --version | sed 's/Google Chrome //g' | sed 's/\..*//') \
    && echo "Installed Chrome version: $CHROME_VERSION" \
    && CHROMEDRIVER_VERSION="134.0.6998.165" \
    && echo "Installing ChromeDriver version: $CHROMEDRIVER_VERSION" \
    && wget https://chromedriver.storage.googleapis.com/$CHROMEDRIVER_VERSION/chromedriver_linux64.zip -O chromedriver.zip \
    && unzip chromedriver.zip -d /usr/local/bin/ \
    && rm chromedriver.zip

# Ensure chromedriver has execute permissions
RUN chmod +x /usr/local/bin/chromedriver

# Set the working directory
WORKDIR /app

# Copy your requirements.txt file to the container
COPY python_requirements.txt .

# Install Python dependencies from the requirements file
RUN pip install --no-cache-dir -r python_requirements.txt
