provider "google" {
  version     = "1.4.0"
  credentials = "${file("../../gcp_credentials.json")}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_compute_instance" "gitlab-ci-env" {
  count        = "${var.vm_count}"
  name         = "${var.instance_name}-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["gitlab-ci-env-${var.commit_sha}"]

  # startup image
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  # network config
  network_interface {
    # set network for interface
    network = "default"

    # set ephemeral external IP
    access_config {}
  }

  # ssh keys
  metadata {
    ssh-keys               = "appuser:${file(var.public_key_path)}"
    block-project-ssh-keys = false
  }
}
