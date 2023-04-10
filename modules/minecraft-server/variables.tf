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

variable "minecraft_server_network_tag" {
  type = string
  default = "mincraft-server-nt"
}

variable "minecraft_servert_vpc_name" {
  type = string
  default = "minecraft-vpc"
}

variable "minecraft_specific_firewall_rule_name" {
  type = string
  default = "minecraft-rule"
}

variable "server_ssh_firewall_rule_name" {
  type = string
  default = "minecraft-allow-server-ssh-rule"
}

variable "static_ip_name" {
  type = string
  default = "minecraft-server-ip"
}

variable "persistent_disk_name" {
  type = string
  default = "minecraft-server-ssd-disk"
}
