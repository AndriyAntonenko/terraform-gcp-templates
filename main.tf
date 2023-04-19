provider "google" {
  project = var.project_id
  region  = var.region
}

# ===========================================
# ============ MINECRAFT SERVER =============
# ===========================================
# module "minecraft" {
#   source     = "./modules/minecraft-server"
#   project_id = var.project_id
#   region     = var.region
#   zone       = var.zone
# }

# ===========================================
# ========== HTTP LOAD BALANCER ==========
# ===========================================
module "http-lb-dev" {
  source     = "./modules/http-lb"

  cluster_name     = "development"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
  instance_startup_script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install apache2 -y
      a2ensite default-ssl
      a2enmod ssl
      vm_hostname="$(curl -H "Metadata-Flavor:Google" \
      http://169.254.169.254/computeMetadata/v1/instance/name)"
      echo "Page served from: $vm_hostname" | \
      tee /var/www/html/index.html
      systemctl restart apache2
    EOF
}

# ===========================================
# ========== NETWORK LOAD BALANCER ==========
# ===========================================

# module "network-lb-dev" {
#   source = "./modules/network-lb"

#   project_id = var.project_id
#   region     = var.region
#   zone       = var.zone

#   instances = [
#     {
#       name = "www-1"
#       machine_type = "e2-small"
#       boot_image = "debian-cloud/debian-11"
#       script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www1</h3>' | tee /var/www/html/index.html"
#     },
#     {
#       name = "www-2"
#       machine_type = "e2-small"
#       boot_image = "debian-cloud/debian-11"
#       script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www2</h3>' | tee /var/www/html/index.html"
#     },
#     {
#       name = "www-3"
#       machine_type = "e2-small"
#       boot_image = "debian-cloud/debian-11"
#       script = "apt-get update && apt-get install apache2 -y && service apache2 restart && echo '<h3>Web Server: www3</h3>' | tee /var/www/html/index.html"
#     }
#   ]
# }
