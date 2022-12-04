variable "hcloud_token" {
  type    = string
  default = env("HCLOUD_TOKEN")
}

source "hcloud" "microos-snapshot" {
  image       = "ubuntu-20.04"
  rescue      = "linux64"
  location    = "nbg1"
  server_type = "cx21" # at least 40GiB disk is needed for MicroOS image
  snapshot_labels = {
    microos-snapshot = "yes"
  }
  snapshot_name = "microos-snapshot"
  ssh_username  = "root"
  token         = var.hcloud_token
}

build {
  sources = ["source.hcloud.microos-snapshot"]

  # install MicroOS image and reboot
  provisioner "shell" {
    script            = "scripts/install_microos.sh"
    expect_disconnect = true
  }

  # optional: install rke2 dependencies

  provisioner "file" {
    source      = "scripts/install_rke2.sh"
    destination = "/tmp/install_rke2.sh"
  }
  provisioner "shell" {
    inline = [
      "transactional-update shell < /tmp/install_rke2.sh"
    ]
  }

  # Ensure connection to MicroOS and do house-keeping
  provisioner "shell" {
    inline = [
      "echo Reboot successful, cleanup....",
      "rm -rf /var/log/*"
    ]
  }
}
