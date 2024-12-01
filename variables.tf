variable "project_id" {
  description = "The GCP project ID."
  type        = string
}

variable "region" {
  description = "The GCP region where Cloud Run will be deployed."
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "The name of the Cloud Run service."
  type        = string
  default     = "react-spring-app"
}

variable "image_tag" {
  description = "The tag of the Docker image to be deployed."
  type        = string
  default     = "latest"
}

variable "user_email" {
  description = "The email address of the user to be granted IAM permissions."
  type        = string
}
