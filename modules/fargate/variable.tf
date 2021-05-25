variable "app_name" {
}

variable "ordered_placement_type" {
    default = "binpack"
}

variable "ordered_placement_field" {
    default = "cpu"
}

variable "image_url" {
    default = "alpine:latest"
}

variable "container_port" {
  description = "Port exposed by the Docker image to redirect traffic to"
  default = 80
}
variable "container_count" {
  description = "Number of Docker containers to run"
  default = 2
}
variable "container_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  default = "512"
}
variable "container_memory" {
  description = "Fargate instance memory to provision (in MiB)"
  default = "512"
}

variable "aws_region" {
  default = "ap-southeast-1"
}

variable "az_a" {
  default = "ap-southeast-1a"
}

variable "az_b" {
  default = "ap-southeast-1b"
}



