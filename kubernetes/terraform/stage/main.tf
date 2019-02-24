provider "google" {
  version = "2.0.0"
  project = "${var.project}"
  region  = "${var.region}"
}

module "k8s" {
  source             = "../modules/k8s"
  public_key_path    = "${var.public_key_path}"
  env                = "${var.env}"
  cluster_name       = "${var.cluster_name}"
  cluster_min_ver    = "${var.cluster_min_ver}"
  project            = "${var.project}"
  zone               = "${var.zone}"
  nodes_count        = "${var.nodes_count}"
  nodes_machine_type = "${var.nodes_machine_type}"
  nodes_disk_size    = "${var.nodes_disk_size}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = ["${var.source_ranges}"]
  env           = "${var.env}"
}
