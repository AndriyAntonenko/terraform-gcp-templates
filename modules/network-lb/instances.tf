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
