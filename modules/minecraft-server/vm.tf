provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_disk" "minecraft_ssd_disk" {
  name  = "minecraft-disk"
  type  = "pd-ssd"
  zone  = var.zone
  image = "debian-11-bullseye-v20220719"
  labels = {
    environment = "minecraft-server"
  }
  size = var.disk_size_gb
}

resource "google_compute_instance" "mincraft_server" {
  name         = var.instance.name
  machine_type = var.instance.machine_type
  zone         = var.zone
  tags         = ["minecraft-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.minecraft_vpc.name
    access_config {
      nat_ip = google_compute_address.minecraft_server_ip.address
    }
  }

  allow_stopping_for_update = true
  metadata_startup_script = <<-EOF
      #!/bin/bash
      sudo apt-get update
      sudo apt-get install -y default-jre-headless
      sudo apt-get install -y wget
      mkdir -p /home/minecraft
      sudo mount -o discard,defaults /dev/disk/by-id/google-minecraft-disk /home/minecraft
      cd /home/minecraft
      echo "eula=true" > '/home/minecraft/eula.txt'
      sudo wget https://launcher.mojang.com/v1/objects/d0d0fe2b1dc6ab4c65554cb734270872b72dadd6/server.jar
      mount /dev/disk/by-id/google-minecraft-disk /home/minecraft
      sudo java -Xmx1024M -Xms1024M -jar server.jar nogui
    EOF
}

resource "google_compute_attached_disk" "attached_minecraft_sdd" {
  disk     = google_compute_disk.minecraft_ssd_disk.id
  instance = google_compute_instance.mincraft_server.id
}
