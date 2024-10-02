# Use the official Python image based on Alpine Linux
FROM python:3-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the local index.html file to the working directory in the container
COPY index.html .

# Expose port 8000
EXPOSE 8000

# Run a Python HTTP server to serve the index.html on port 8000
CMD ["python3", "-m", "http.server", "8000"]
