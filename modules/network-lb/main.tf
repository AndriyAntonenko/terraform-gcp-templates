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

resource "google_compute_address" "network_lb_ip" {
  name    = "network-lb-ip"
  region  = var.region
  network = google_compute_network.network_lb_network.name
}

resource "google_compute_http_health_check" "health_check" {
  name = "basic-check"
}

resource "google_compute_target_pool" "target_pool" {
  name      = "network-lb-pool"
  instances = [for instance in var.instances : format("%s/%s", var.zone, instance.name)]
  health_checks = [
    google_compute_http_health_check.health_check.name,
  ]
}

resource "google_compute_forwarding_rule" "www_rule" {
  name       = "network-lb-rule"
  port_range = "80"
  region     = var.region
  target     = google_compute_target_pool.target_pool.self_link
  ip_address = google_compute_address.network_lb_ip.self_link
}

resource "google_compute_instance" "instances" {
  count = length(var.instances)
  name  = var.instances[count.index].name
  zone  = var.zone

  tags         = [var.network_lb_tag]
  machine_type = var.instances[count.index].machine_type
  boot_disk {
    initialize_params {
      image = var.instances[count.index].boot_image
    }
  }

  network_interface {
    network = google_compute_network.network_lb_network.name
    access_config {}
  }

  depends_on                = [google_compute_network.network_lb_network]
  allow_stopping_for_update = true
  metadata_startup_script   = var.instances[count.index].script
}
