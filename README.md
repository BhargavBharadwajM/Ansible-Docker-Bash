# Ansible-Docker-Bash
# Automated Docker Life-cycle Management and AWS Service Monitoring

## Overview

This project automates the lifecycle management of Docker containers and monitors AWS services using Ansible, Docker, Bash scripts, and cron jobs in a WSL environment.

It includes two main components:
1. **Automated Docker Management**: Using Ansible to automate Docker container creation, deployment, and lifecycle management.
2. **AWS Service Monitoring**: A set of Bash scripts to install the AWS CLI and list AWS resources, such as EC2, S3, Lambda, and more.

---

## Project Structure

- **ansible-playbooks/**: Contains Ansible playbooks to manage Docker containers.
  - `docker_create.yml`: Creates and runs a Docker container using a Python-based HTTP server to serve an `index.html` file.
  - `docker_manage.yml`: Manages running Docker containers (stops and removes them).

- **docker/**: Contains Dockerfile and `index.html` used to build the Docker image.
  - `Dockerfile`: Configuration file to create a Docker image based on Alpine Linux and Python to serve the web page.
  - `index.html`: The web page served by the Python HTTP server in the container.

- **scripts/**: Bash scripts for AWS CLI installation and AWS resource listing.
  - `aws_install.sh`: Installs and configures AWS CLI.
  - `aws_resource_list.sh`: Lists AWS resources for services like EC2, VPC, Lambda, etc.
  - `log_script.sh`: Counts the number of successful HTTP responses (status code 200) from the Docker container logs.

---

## How to Use

### Prerequisites

- Install [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- Ensure Docker is installed on the remote VMs.
- AWS credentials must be configured.

### Docker Setup

The Dockerfile uses the official Python image based on Alpine Linux to create a lightweight HTTP server that serves the `index.html` file.

```Dockerfile
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

```
### Ansible Playbooks

- **Docker Creation Playbook**
    This playbook creates a Docker container using the above Dockerfile and serves the index.html on port 8000 using a Python HTTP server.
    CMD to use
    ansible-playbook ansible-playbooks/docker_create.yml
- **Docker Management Playbook**
    This playbook lists, stops, and removes all running Docker containers.
    CMD to use
    ansible-playbook ansible-playbooks/docker_manage.yml

### Automation with Cron Jobs

- This system is configured to run weekly through cron jobs. It includes:

  - Docker Management: Stops and removes Docker containers every day.
  - HTTP Response Logging: Counts successful HTTP responses from the Docker container every day.
  - AWS Resource Monitoring: Lists AWS resources and logs success codes weekly.
    
- To set up the cron jobs, modify your crontab:
  - crontab -e
  - Add the following entries to automate weekly execution:
    -  Create Docker container every day at 9:00 AM
       -0 9 * * * ansible-playbook /path_to_your_repo/ansible-playbooks/docker_create.yml

       Log successful HTTP responses every day at 9:01 AM
       -1 9 * * * bash /path_to_your_repo/scripts/log_script.sh >> /home/phoenix/logs/log_output.log

       Manage Docker containers every day at 9:20 AM
       -20 9 * * * ansible-playbook /path_to_your_repo/ansible-playbooks/docker_manage.yml

       Monitor AWS services and log results weekly at 1:00 AM every Sunday
       -0 1 * * 0 bash /path_to_your_repo/scripts/aws_resource_list.sh <aws_region> <aws_service>

  - In this configuration:

    9:00 AM: Docker container is created.
    9:01 AM: Log script runs to count successful 200 HTTP responses, outputting to log_output.log.
    9:20 AM: Docker management script runs to stop and remove containers.
    1:00 AM on Sunday: AWS resource listing script runs.


