# 🧠 Octabyte DevOps Assignment

### 👩‍💻 Author: *Anisha Sarkar*

This repository contains the complete solution for the **Octabyte DevOps assignment**, including Infrastructure Provisioning, CI/CD Automation, Monitoring setup, and Documentation with best practices.

**PROJECT STRUCTURE**

<img width="500" height="400" alt="image" src="https://github.com/user-attachments/assets/9746993d-057f-4d33-9beb-92046ffca692" />



## 🧩 Part 1 — Infrastructure Provisioning (Terraform on Azure)

**Goal:** Provision a scalable infrastructure setup on Azure using Terraform.

### Resources Defined
- Virtual Network (VNet)  
- Public subnet  
- Linux Virtual Machine (for application hosting)  
- PostgreSQL database (RDS equivalent)  
- Network Security Groups  
- Load Balancer configuration  
- Outputs and variables for reusability  
- Remote backend (state management ready)

### 🛠️ How to Set Up
```bash
cd terraform
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"


If no Azure account is available, terraform plan validates your configuration syntax and logic.

📘 Files: main.tf, variables.tf, outputs.tf, backend.tf, dev.tfvars

⚙️ Part 2 — Deployment Automation (CI/CD with Jenkins)
Goal: Automate the complete application lifecycle from build to deployment.

Key Pipeline Features

Trigger on GitHub webhook (push to main)
Install dependencies
Run unit & integration tests
Vulnerability scan using Trivy
Build & push Docker image to Docker Hub
Manual approval before production deployment
Email notifications on success/failure


📘 File: Jenkinsfile

📊 Part 3 — Monitoring and Logging (Prometheus + Grafana)
Goal: Implement centralized monitoring for infrastructure and application metrics.

Setup Includes

Prometheus → collects metrics

Node Exporter → infrastructure metrics (CPU, memory, disk)

Prometheus Flask Exporter → application metrics (requests, errors, latency)

Grafana → dashboards and visualizations

Dashboards Used

Node Exporter Full (ID: 1860) — infrastructure metrics
Flask / Prometheus metrics (ID: 4701) — application metrics


📘 Files:
infra/docker-compose.yml
infra/prometheus.yml


app/app.py (instrumented for Prometheus)


🐳 Running the Monitoring Stack Locally

Prerequisites

Docker & Docker Compose installed
Flask app running (optional for app metrics)

Steps
cd infra
docker-compose up -d

URLs:

Prometheus → http://localhost:9090

Grafana → http://localhost:3000

Login: admin / admin

Add Prometheus as data source → http://prometheus:9090

🧪 Running the Flask Application
cd app
pip install -r requirements.txt
python app.py

App runs at → http://localhost:5000
Metrics exposed at → http://localhost:5000/metrics

📬 Notifications

Jenkins sends email alerts for build success/failure.

Slack integration optional (email used for this setup).


🏗️ Architecture Decisions

Terraform for IaC: Portable, declarative infrastructure management.

Docker: Provides consistent application environments across local and CI/CD.

Jenkins: Chosen for self-hosted CI/CD flexibility and manual approval capabilities.

Prometheus + Grafana: Open-source, lightweight, and ideal for local or cloud setups.

Azure (or any cloud): Code modular enough to switch between cloud providers.


🔒 Security Considerations


Sensitive data (GitHub token, Docker credentials) stored in Jenkins Credentials Manager.

Environment variables and .tfvars files excluded from Git history.

Security groups restrict inbound access to required ports only (22, 80, 5000).

Vulnerability scanning included via Trivy before Docker image deployment.

Minimal packages in Docker image to reduce attack surface.



💰 Cost Optimization Measures

Infrastructure designed with small instance sizes and single-region deployment.

Option to destroy resources easily via terraform destroy.

Use of Docker Compose locally instead of multiple VMs for monitoring reduces cost.

Modular configuration supports scaling only when required.


🔐 Secret Management


All credentials handled through Jenkins Credentials Plugin.

Alternative for production:

Azure Key Vault or AWS Secrets Manager integration via Terraform.

Example snippet:
data "azurerm_key_vault_secret" "db_password" {
  name         = "db-password"
  key_vault_id = azurerm_key_vault.example.id
}
