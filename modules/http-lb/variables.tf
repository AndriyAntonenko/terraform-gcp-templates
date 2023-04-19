variable "cluster_name" {
  type    = string
  default = "my-http-lb"
}

variable "project_id" {
  type = string
}

variable "zone" {
  type = string
}

variable "region" {
  type = string
}

variable "instance_startup_script" {
  type = string
}

variable "autoscaling" {
  type = object({
    max_replicas    = number
    min_replicas    = number
    cooldown_period = number
  })
  default = {
    max_replicas = 3
    min_replicas = 1
    cooldown_period = 60
  }
}
