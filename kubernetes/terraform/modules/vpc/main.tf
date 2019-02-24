resource "google_compute_firewall" "k8s_fw_rule" {
  name    = "default-allow-ingress-k8s"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = "${var.source_ranges}"
}
