variable project {
  description = "Project id"
}

variable public_key_path {
  description = "Path to the public key used to connect to instance"
}

variable env {
  description = "Environment type"
  default     = "stage"
}

variable cluster_name {
  description = "Cluster name"
}

variable cluster_min_ver {
  description = "Min master version"
}

variable region {
  description = "Region"
}

variable zone {
  description = "Zone"
}

variable nodes_count {
  description = "Nodes count"
  default     = "3"
}

variable nodes_machine_type {
  description = "Nodes machine type"
}

variable nodes_disk_size {
  description = "Nodes disk size"
}

variable source_ranges {
  description = "Allowed IP addresesses"
  type        = "list"
  default     = ["0.0.0.0/0"]
}
