terraform {
    required_providers {
        google = {
            source  = "hashicorp/google"
            version = "~> 5.21.0"
        }
    } 
}

provider "google" {
    credentials = file("gcp_key.json")
    project     = var.project_id
    region      = var.region
}

provider "google-beta" {
    credentials = file("gcp_key.json")
    project     = var.project_id
    region = var.region
}