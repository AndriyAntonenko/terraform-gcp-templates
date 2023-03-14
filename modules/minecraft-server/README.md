# Minecraft Server

Example of virtual machine with attached SSD Persistent Disk with Minecraft Game Server installed on it.
This example based on Cloud Skill Boost Lab [Working with Virtual Machines](https://www.cloudskillsboost.google/course_sessions/2412566/labs/351460)

Example of usage:

```terraform
provider "google" {
  project = var.project_id
  region  = var.region
}

# ===========================================
# ============ MINECRAFT SERVER =============
# ===========================================
module "minecraft" {
  source     = "./modules/minecraft-server"
  project_id = var.project_id
  region     = var.region
  zone       = var.zone
}
```
