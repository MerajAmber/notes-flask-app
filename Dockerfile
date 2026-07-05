# Use official Python 3.14 slim image
FROM python:3.14-slim

# Prevent Python from writing .pyc files
ENV PYTHONDONTWRITEBYTECODE=1

# Display Python logs immediately
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

# Install system dependencies required for mysqlclient
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc \
        build-essential \
        default-libmysqlclient-dev \
        pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements first (Docker layer caching)
COPY requirements.txt .

# Upgrade pip and install Python dependencies
RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy application source code
COPY . .

# Expose Flask port
EXPOSE 5000

# Start the application
CMD ["python", "app.py"]