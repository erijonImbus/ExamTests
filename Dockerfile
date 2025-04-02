FROM python:3.11-slim

# Set environment variables to avoid Python buffering and for easier troubleshooting
ENV PYTHONUNBUFFERED=1
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for Selenium, Chrome, Firefox, Edge, and their drivers
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
    fonts-liberation \
    libxi6 \
    libgconf-2-4 \
    # Install dependencies for Firefox and Microsoft Edge
    libdbus-1-3 \
    libxtst6 \
    libxss1 \
    libappindicator3-1 \
    libnss3 \
    libgdk-pixbuf2.0-0 \
    libasound2 \
    && rm -rf /var/lib/apt/lists/*

# Install Google Chrome stable version
RUN curl -LO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get install -y ./google-chrome-stable_current_amd64.deb && \
    rm google-chrome-stable_current_amd64.deb

# Install Firefox
RUN apt-get update && apt-get install -y firefox-esr

# Install Microsoft Edge
RUN wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | apt-key add - \
    && wget -q https://packages.microsoft.com/repos/edge/pool/main/m/microsoft-edge-dev/microsoft-edge-dev_112.0.1722.48-1_amd64.deb \
    && dpkg -i microsoft-edge-dev_112.0.1722.48-1_amd64.deb \
    && apt --fix-broken install -y

# Set the working directory
WORKDIR /app

# Copy your requirements.txt file to the container
COPY python_requirements.txt .

# Install Python dependencies from the requirements file
RUN pip install --no-cache-dir -r python_requirements.txt
RUN pip install --upgrade selenium
