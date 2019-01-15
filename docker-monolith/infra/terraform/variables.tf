variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable private_key_path {
  description = "Path to the private key used by provisioners"
}

variable disk_image {
  description = "Disk image"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable vm_count {
  description = "Number of VM for cluster"
  default     = "1"
}
