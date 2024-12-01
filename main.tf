provider "google" {
  project     = var.project_id
  region      = var.region
}

# Random ID for unique bucket name
resource "random_id" "default" {
  byte_length = 8
}


# Create Google Storage Bucket for Terraform state
resource "google_storage_bucket" "default" {
  name     = "${random_id.default.hex}-${var.project_id}-tf"
  location = us-central-1

  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true

  versioning {
    enabled = true
  }
}

# Create backend.tf file for remote state storage
resource "local_file" "backend_config" {
  filename        = "${path.module}/backend.tf"
  file_permission = "0644"

  content = <<-EOT
  terraform {
    backend "gcs" {
      bucket = "${google_storage_bucket.default.name}"
    }
  }
  EOT
}

resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"
}

resource "google_project_service" "container_registry" {
  project = var.project_id
  service = "containerregistry.googleapis.com"
}

resource "google_project_service" "monitoring" {
  project = var.project_id
  service = "monitoring.googleapis.com"
}

resource "google_project_service" "logging" {
  project = var.project_id
  service = "logging.googleapis.com"
}

resource "google_storage_bucket" "gcr_bucket" {
  name     = "gcr-${var.project_id}"
  location = "us-central-1"
}

resource "google_cloud_run_service" "app_service" {
  name     = var.cloud_run_service_name
  location = var.region
  project  = var.project_id

}

resource "google_project_iam_member" "cloud_run_user" {
  project = var.project_id
  role    = "roles/run.invoker"
  member  = "user:${var.user_email}"
}

resource "google_monitoring_alert_policy" "alert_policy" {
  display_name = "Cloud Run Health Alerts"
  notification_channels = [google_monitoring_notification_channel.email.id]

  # Define how conditions are combined
  combiner = "OR"  # OR means the policy is triggered if any condition is met

  conditions {
    display_name = "Cloud Run Service Error"
    condition_threshold {
      comparison = "COMPARISON_GT"
      threshold_value = 0
      aggregations {
        alignment_period   = "60s" # Alignment period of 60 seconds
        per_series_aligner = "ALIGN_RATE" # Align the data by computing the rate of change
      }
      duration = "60s"  # Duration for which the condition must persist
    }
  }
}

