provider "google" {
  project = var.project_id
  region  = var.region
}

module "network-lb-dev" {
  source = "./modules/network-lb"

  project_id = var.project_id
  region     = var.region
  zone       = var.zone

  instances = [
    {
      name = "www-1"
      machine_type = "e2-small"
      boot_image = "debian-cloud/debian-11"
      script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www1</h3>' | tee /var/www/html/index.html"
    },
    {
      name = "www-2"
      machine_type = "e2-small"
      boot_image = "debian-cloud/debian-11"
      script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www2</h3>' | tee /var/www/html/index.html"
    },
    {
      name = "www-3"
      machine_type = "e2-small"
      boot_image = "debian-cloud/debian-11"
      script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www3</h3>' | tee /var/www/html/index.html"
    }
  ]
}
