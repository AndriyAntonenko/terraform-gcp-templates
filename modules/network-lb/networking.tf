resource "google_compute_address" "network_lb_ip" {
  name   = "network-lb-ip"
  region = var.region
}

resource "google_compute_http_health_check" "health_check" {
  name = "basic-check"
}

resource "google_compute_target_pool" "target_pool" {
  name = "network-lb-pool"

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
