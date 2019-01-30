provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "gitlab-runner" {
  count        = "${var.vm_count}"
  name         = "gitlab-runner-${count.index}"
  machine_type = "g1-small"
  zone         = "${var.zone}"
  tags         = ["gitlab-runner"]

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

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
}
