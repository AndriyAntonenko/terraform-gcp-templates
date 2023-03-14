variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "region" {
  type = string
}

variable "instance" {
  type = object({
    name         = string
    machine_type = string
  })

  default = {
    name         = "minecraft-server"
    machine_type = "e2-medium"
  }
}

variable "disk_size_gb" {
  type    = number
  default = 50
}
