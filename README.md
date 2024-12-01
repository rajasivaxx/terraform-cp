# CI/CD for GCP Cloud Run Deployment

This repository contains a CI/CD pipeline configured with GitHub Actions to deploy a Google Cloud Run infrastructure along with cloud monitoring using Terraform. The pipeline automatically sets up the necessary GCP resources and deploys the application to Cloud Run.

## Prerequisites

Before running the pipeline, ensure the following:

- A Google Cloud Platform (GCP) project.
- GitHub repository with your containerized application.
- Google Cloud account with appropriate IAM permissions.

## Setup

### 1. Configure GitHub Secrets

To authenticate with Google Cloud, you need to set up the following secrets in your GitHub repository:

- **`GCP_SA_KEY`**: The Service Account Key JSON for authentication. This service account should have sufficient permissions (e.g., `roles/run.admin`, `roles/iam.serviceAccountUser`).
  

### 2. Provide the GCP Project ID

In the GitHub Actions workflow file (`.github/workflows/ci-cd.yaml`), ensure that the correct GCP project ID is set in terraform.tfavrs. The pipeline uses this value to deploy the application to Cloud Run.


### 3. Trigger the Pipeline

Once the secrets are configured and the repository is pushed, the GitHub Actions pipeline will be triggered automatically.


### 4. Cloud Run Deployment

Upon successful execution of the CI/CD pipeline, the following will happen:
- Terraform will initialize and configure the GCP resources required for Cloud Run.

### 5. Verify Deployment

Once the pipeline completes, check the Cloud Run service in the [Google Cloud Console](https://console.cloud.google.com/run).

### 6. Clean Up Resources

To clean up the deployed resources, you can delete the Cloud Run service and other associated infrastructure by running `terraform destroy` in the pipeline or manually via Google Cloud Console.

