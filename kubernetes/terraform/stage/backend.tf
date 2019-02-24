terraform {
  backend "gcs" {
    bucket = "reddit-app-storage-stage"
    prefix = "terraform-state"
  }
}
