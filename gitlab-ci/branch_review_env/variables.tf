variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
  default     = "../../appuser.pub"
}

variable disk_image {
  description = "Disk image"
  default     = "docker-monolith"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable vm_count {
  description = "Number of VM for cluster"
  default     = "1"
}

variable instance_name {
  description = "Name for created instance"
}

variable commit_sha {
  description = "SHA of commit"
}
