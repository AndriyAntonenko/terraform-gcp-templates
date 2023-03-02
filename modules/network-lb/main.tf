provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "network_lb_network" {
  name = var.vpc_name
}

resource "google_compute_firewall" "firewall" {
  name          = "firewall-network-lb"
  target_tags   = [var.network_lb_tag]
  source_ranges = ["0.0.0.0/0"]
  network       = var.vpc_name
  depends_on    = [google_compute_network.network_lb_network]
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}
