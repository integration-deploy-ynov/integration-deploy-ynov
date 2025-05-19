variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "europe-west1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default     = "europe-west1-b"
}

variable "credentials_file" {
  description = "Path to GCP service account JSON file"
  type        = string
  default     = "./key-projetindividuel.json"
}
