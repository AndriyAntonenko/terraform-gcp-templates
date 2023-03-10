variable "prefix" {
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
