# HTTP(S) Load Balancer

Example of terraform module for configuring external http load balancer on the Google Cloud Platform with Instances Group as a Backend.
This example based on Cloud Skill Boost Lab [Set Up Network and HTTP Load Balancers](https://www.cloudskillsboost.google/focuses/12007?parent=catalog)

Example of usage:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# ===========================================
# ========== HTTP LOAD BALANCER ==========
# ===========================================
module "http-lb-dev" {
  source     = "./modules/http-lb"

  prefix     = "development"
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
```
