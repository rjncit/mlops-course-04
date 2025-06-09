FROM python:3.13-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Health check configuration
HEALTHCHECK --interval=10s --timeout=5s \
            --start-period=30s --retries=3 \
            CMD curl -f http://localhost:80/health || exit 1

# Explicit port exposure
EXPOSE 80

# Production server configuration
CMD ["gunicorn", "-w", "4", "-k", "uvicorn.workers.UvicornWorker", \
     "--bind", "0.0.0.0:80", "--timeout", "120", \
     "--access-logfile", "-", "app:app"]