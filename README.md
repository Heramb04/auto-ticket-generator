
# Automated Incident Management & DevOps Monitoring Pipeline

This project implements a self-healing DevOps pipeline that integrates CI/CD automation, real-time infrastructure monitoring, and automated incident management. It demonstrates a closed-loop system where build failures or system anomalies automatically trigger ticket creation in Jira, reducing manual oversight and improving incident response times.

## Architecture

The system consists of three core pillars:

1.  **Orchestration (Jenkins & Docker):**

      * Jenkins runs as the CI/CD server, managing build lifecycles.
      * Docker is used for containerizing applications and isolating build environments.
      * The pipeline automatically detects code changes and triggers build processes.

2.  **Monitoring (Prometheus & Grafana):**

      * **cAdvisor:** Exports real-time resource usage metrics (CPU, Memory, Network) from running Docker containers.
      * **Prometheus:** Scrapes and stores time-series data from cAdvisor and Jenkins.
      * **Grafana:** Visualizes system health via a centralized dashboard and manages alerting rules.

3.  **Incident Management (Jira):**

      * A custom integration logic acts as the bridge between the technical stack and project management.
      * Build failures in Jenkins automatically invoke the Jira REST API to create specific bug reports.
      * High-resource usage alerts from Prometheus/Grafana trigger priority incidents for the Operations team.

## Prerequisites

Before running this project, ensure your environment meets the following requirements:

### System Requirements

  * **Operating System:** Linux (Ubuntu/Fedora/CentOS) recommended, or macOS/Windows with WSL2.
  * **Resources:** Minimum 4GB RAM (to run Jenkins, Grafana, and Prometheus simultaneously).

### Software Dependencies

  * **Docker Engine:** v20.10 or higher.
  * **Docker Compose:** v2.0 or higher.
  * **Git:** For cloning the repository.
  * **Curl:** For API testing (optional but recommended).

### Cloud Services & Credentials

  * **Jira Cloud Account:** You need an active Jira workspace.
  * **Jira API Token:** Required for authentication (Passwords are not supported for API calls).
  * **Network Access:** Port 8080 (Jenkins), 3000 (Grafana), and 9090 (Prometheus) must be open on your local machine.

## Installation & Setup

### 1\. Clone the Repository

```bash
git clone https://github.com/Heramb04/auto-ticket-generator.git
cd auto-ticket-generator
```

### 2\. Configure Monitoring Stack

Navigate to the monitoring directory and start the observability services.

```bash
cd monitoring
docker-compose up -d
```

This will initialize:

  * **Prometheus:** http://localhost:9090
  * **Grafana:** http://localhost:3000 (Default login: admin/admin)
  * **cAdvisor:** http://localhost:8080

### 3\. Configure Jenkins

1.  Start the Jenkins container (or ensure it is running on your host).
2.  Install the **"Jira Pipeline Steps"** plugin via the Jenkins Plugin Manager.
3.  Configure global credentials:
      * Go to **Manage Jenkins \> Credentials**.
      * Add a new `Username with password` credential.
      * **ID:** `jira-creds`
      * **Username:** Your Jira Email.
      * **Password:** Your Jira API Token.

## Usage Guide

### Connecting Grafana to Prometheus

1.  Log in to Grafana.
2.  Navigate to **Connections \> Data Sources \> Add new**.
3.  Select **Prometheus**.
4.  Set the connection URL to `http://prometheus:9090` (internal Docker network).
5.  Save and Test.

### Importing the Dashboard

1.  Go to **Dashboards \> New \> Import**.
2.  Enter the dashboard ID `14282` (Docker Container & Host Metrics).
3.  Select the Prometheus data source configured above.
4.  Click **Import** to view real-time metrics.

### Triggering the Pipeline

The `Jenkinsfile` in this repository contains the logic for the automated build and reporting.

1.  Create a new Pipeline job in Jenkins.
2.  Point the job to this GitHub repository.
3.  Run the build.
4.  Verify that a successful build logs output to the console, and a failed build (simulated) creates a ticket in your Jira project.

## Project Configuration

### Jira Environment Variables

Ensure the following variables are set within the Jenkins Pipeline script or Global Environment variables:

  * `JIRA_URL`: The base URL of your Jira instance (e.g., [https://your-domain.atlassian.net](https://your-domain.atlassian.net)).
  * `PROJECT_KEY`: The project key where tickets should be created (e.g., KAN, SCRUM).
