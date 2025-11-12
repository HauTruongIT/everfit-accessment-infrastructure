# Everfit Assessment Infrastructure

This repository is the centralized deployment manager for all Everfit microservices. It uses Helm charts, environment-specific values files, and GitHub Actions to automate deployments to a shared Kubernetes cluster.

## Overview

- **Purpose:** Centralized management of microservice deployments.
- **Scope:** Helm charts, values files, and deployment automation.

## Deployment Workflow

1. **Image Tag Update**
   - When a microservice (e.g., [`everfit-assessment-application`](https://github.com/HauTruongIT/everfit-assessment-application)) completes its CI pipeline, it creates a PR here updating the Docker image tag in the appropriate Helm values file (e.g., `dev/demo-app.yaml`).

2. **PR Detection & Deployment**
   - On PR merge, GitHub Actions detects changes to Helm values.
   - The pipeline applies the update to the Kubernetes cluster using Helm, targeting the correct namespace (`dev`, `sit`, etc.).

3. **Centralized Control**
   - All deployments are managed here, ensuring consistency and observability.


## Directory Structure

```
everfit-assessment-infrastructure/
├── modules/                     # Reusable Terraform modules
│   └── github-runners/          # GitHub Actions runner module
│       ├── main.tf              # IAM roles and EC2 instance definitions
│       ├── variables.tf         # Module variables with defaults
│       ├── outputs.tf           # Module outputs
│       ├── data.tf              # Data sources (AWS account ID, subnet lookup)
│       └── README.md            # Module documentation
├── global/                      # Global Terraform/IaC configs
│   └── github-runners/          # GitHub Actions runner configuration
│       ├── main.tf              # Module consumer (calls the module)
│       ├── variables.tf         # Input variables for the module
│       ├── outputs.tf           # Exposed module outputs
│       ├── terraform.tfvars     # Variable values (update with your values)
│       ├── backend.tf           # Terraform backend configuration
│       ├── locals.tf            # Local values
│       ├── providers.tf         # AWS provider configuration
│       └── .terraform.lock.hcl  # Terraform lock file
├── charts/                      # Helm charts for microservices
│   ├── Chart.yaml               # Chart metadata for demo-app
│   ├── values.yaml              # Default Helm values
│   └── templates/               # Helm templates
│       ├── deployment.yaml      # Kubernetes Deployment template
│       ├── service.yaml         # Kubernetes Service template
│       └── _helpers.tpl         # Helm helper templates
├── dev/                         # Development environment values
│   └── demo-app.yaml            # Helm values override for demo-app in dev
├── sit/                         # SIT environment values
│   └── demo-app.yaml            # Helm values override for demo-app in SIT
├── .github/                     # GitHub configuration
│   └── workflows/               # GitHub Actions workflows
│       ├── dev.yaml             # Dev deployment workflow (triggered on dev/demo-app.yaml changes)
│       └── sit.yaml             # SIT deployment workflow (triggered on sit/demo-app.yaml changes)
├── .gitignore                   # Git ignore rules
├── README.md                    # Project documentation
└── .terraform/                  # Terraform state and plugins (git-ignored)
```

### Environment & Access

- **Kubeconfig:** Managed via GitHub secrets; runners use `aws eks update-kubeconfig` to authenticate.
- **Helm:** Used for templated, repeatable deployments.
- **GitHub Actions:** Self-hosted runners (e.g., `everfit`) with EKS access.

### Example Workflow Snippet

```yaml
on:
  push:
    branches: [ main ]
    paths:
      - 'values/dev/demo-app.yaml'
jobs:
  deploy:
    runs-on: [self-hosted, everfit]
    steps:
      - run: aws eks update-kubeconfig --region ${{ secrets.EKS_REGION }} --name ${{ secrets.EKS_CLUSTER_NAME }}
      - run: helm upgrade demo-app ./charts/demo-app --namespace dev --values values/dev/demo-app.yaml --install
```

## Benefits of Centralized Deployment

- **Observability:** All deployments are tracked and managed in one place.
- **Separation of CI/CD:** Microservices handle CI; this repo handles CD.
- **Consistency:** Reduces configuration drift and simplifies rollbacks.
- **Scalability:** Easily add new microservices and environments.

## Assessment Requirements Met

- **Infrastructure as Code (IaC):** Helm charts and values files.
- **Automated Pipeline:** GitHub Actions for CI/CD.
- **EKS/ALB/SSL:** Designed for deployment to AWS EKS with best practices.
- **Separation of Concerns:** Clear split between application CI and infrastructure CD.

---
