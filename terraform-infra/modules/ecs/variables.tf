variable "cluster_name" {}
variable "target_group_arn" {}
variable "security_group" {}
variable "container_port" {}

variable "public_subnets" {
  description = "Public subnets for ECS service"
  type        = list(string)
}

variable "private_subnets" {
  type = list(string)
}