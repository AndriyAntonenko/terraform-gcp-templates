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

variable "pool_target_size" {
  type    = number
  default = 2
}
