resource "google_container_cluster" "stage" {
  name                     = "${var.cluster_name}-${var.env}"
  zone                     = "${var.zone}"
  min_master_version       = "${var.cluster_min_ver}"
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = ""
    password = ""
  }

  addons_config {
    kubernetes_dashboard {
      disabled = "false"
    }
  }
  
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

resource "google_container_node_pool" "stage_nodes" {
  name       = "node-pool-${var.cluster_name}-${var.env}"
  zone       = "${var.zone}"
  cluster    = "${google_container_cluster.stage.name}"
  node_count = "${var.nodes_count}"

  node_config {
    preemptible  = false
    machine_type = "${var.nodes_machine_type}"
    disk_size_gb = "${var.nodes_disk_size}"

    metadata {
      ssh-keys = "appuser:${file(var.public_key_path)}"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}
