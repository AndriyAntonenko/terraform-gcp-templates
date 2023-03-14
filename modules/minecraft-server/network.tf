resource "google_compute_network" "minecraft_vpc" {
  name = "minecraft-vpc"
}

resource "google_compute_firewall" "minecraft_rule" {
  name    = "minecraft-rule"
  network = google_compute_network.minecraft_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-server"]
}

# ALLOW SSH CONNECTIONS TO VMS
resource "google_compute_firewall" "ssh_rule" {
  name    = "shh-allow-firewall"
  network = google_compute_network.minecraft_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-server"]
}

resource "google_compute_address" "minecraft_server_ip" {
  name = "minecraft-server-ip"
}
