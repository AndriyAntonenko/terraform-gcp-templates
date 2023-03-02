variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "region" {
  type = string
}

variable "instances" {
  type = list(object({
    name         = string
    machine_type = string
    boot_image   = string
    script       = string
  }))
}

variable "network_lb_tag" {
  type    = string
  default = "network-lb-tag"
}

variable "vpc_name" {
  type    = string
  default = "vpc-network"
}
