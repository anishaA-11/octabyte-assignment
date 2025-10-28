# ------------------------------
# Stage 1: Build the environment
# ------------------------------

# Use lightweight Python image
FROM python:3.10-slim

# Set working directory inside container
WORKDIR /app

# Copy dependency file first (for caching)
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of your app
COPY . .

# Expose Flask's default port
EXPOSE 5000

# Define environment variable (optional)
ENV FLASK_APP=app.py

# Run the application
CMD ["python", "app.py"]
