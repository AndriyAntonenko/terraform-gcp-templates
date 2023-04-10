resource "google_compute_network" "minecraft_vpc" {
  name = var.minecraft_servert_vpc_name
}

resource "google_compute_firewall" "minecraft_rule" {
  name    = var.minecraft_specific_firewall_rule_name
  network = google_compute_network.minecraft_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["25565"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.minecraft_server_network_tag]
}

# ALLOW SSH CONNECTIONS TO VMS
resource "google_compute_firewall" "ssh_rule" {
  name    = var.server_ssh_firewall_rule_name
  network = google_compute_network.minecraft_vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = [var.minecraft_server_network_tag]
}

resource "google_compute_address" "minecraft_server_ip" {
  name = var.static_ip_name
}
