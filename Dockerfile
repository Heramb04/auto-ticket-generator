# Use the official Jenkins Long-Term Support image
FROM jenkins/jenkins:lts

# Switch to root to install system dependencies
USER root

# Install Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io

# Add the jenkins user to the docker group to ensure permissions to access the docker socket
RUN groupadd -f docker && usermod -aG docker jenkins

# Switch back to the standard jenkins user for security
USER jenkins
