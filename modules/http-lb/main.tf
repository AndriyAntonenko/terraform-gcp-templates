provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "network" {
  name = "${var.prefix}-vpc"
}

# ALLOW SSH CONNECTIONS TO VMS
resource "google_compute_firewall" "ssh_rule" {
  name    = "${var.prefix}-shh-allow-firewall"
  network = google_compute_network.network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.prefix}-vm"]
}

# static IP address
resource "google_compute_global_address" "static_ip" {
  name       = "${var.prefix}-ipv4"
  ip_version = "IPV4"
}

resource "google_compute_global_forwarding_rule" "http_rule" {
  name                  = "${var.prefix}-http-fw-rule"
  port_range            = "80"
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.target_proxy.id
  ip_address            = google_compute_global_address.static_ip.id
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.prefix}-url-mapping"
  default_service = google_compute_backend_service.backend_service.id
}

resource "google_compute_target_http_proxy" "target_proxy" {
  name    = "${var.prefix}-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_instance_template" "backend_template" {
  name         = "${var.prefix}-backend-template"
  tags         = ["${var.prefix}-allow-health-check", "${var.prefix}-vm"]
  machine_type = "e2-medium"

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = google_compute_network.network.name
    access_config {}
  }

  metadata = {
    startup-script = var.instance_startup_script
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [google_compute_network.network]
}

resource "google_compute_instance_group_manager" "backend_instance_group" {
  name               = "${var.prefix}-backend-instance-group"
  base_instance_name = "${var.prefix}-backend"
  zone               = var.zone
  target_size        = 2

  depends_on = [google_compute_instance_template.backend_template]

  version {
    name              = "primary"
    instance_template = google_compute_instance_template.backend_template.self_link
  }

  named_port {
    name = "http"
    port = 80
  }
}

resource "google_compute_firewall" "fw_health_check_rule" {
  name        = "${var.prefix}-fw-health-check"
  depends_on  = [google_compute_network.network]
  network     = google_compute_network.network.name
  target_tags = ["${var.prefix}-allow-health-check"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  direction     = "INGRESS"
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
}

resource "google_compute_health_check" "health_check" {
  name = "${var.prefix}-basic-check"
  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend_service" {
  name                  = "${var.prefix}-http-backend-service"
  health_checks         = [google_compute_health_check.health_check.self_link]
  load_balancing_scheme = "EXTERNAL"
  protocol              = "HTTP"
  port_name             = "http"
  backend {
    group = google_compute_instance_group_manager.backend_instance_group.instance_group
  }
}
