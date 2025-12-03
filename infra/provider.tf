terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  credentials = file("${path.module}/retail-etl-proj-427a9aede757.json")
  project     = "retail-etl-proj"
  region      = "europe-west1"
}