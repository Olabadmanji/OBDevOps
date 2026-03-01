variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "project3"
}

variable "environment" {
  default = "production"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "container_port" {
  default = 3000
}

variable "container_cpu" {
  default = 256
}

variable "container_memory" {
  default = 512
}

variable "desired_count" {
  default = 2
}

variable "min_capacity" {
  default = 2
}

variable "max_capacity" {
  default = 10
}

variable "app_db_password" {
  description = "Stored in Secrets Manager"
  sensitive   = true
}