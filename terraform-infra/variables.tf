variable "aws_region" {
  default = "us-east-1"
}

variable "project_name" {
  default = "greenfield"
}

variable "container_port" {
  default = 3000
}

variable "desired_count" {
  default = 1
}

variable "db_name" {
  default = "greenfield"
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}