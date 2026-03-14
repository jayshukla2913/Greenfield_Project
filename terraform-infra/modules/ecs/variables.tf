variable "cluster_name" {}
variable "target_group_arn" {}
variable "security_group" {}
variable "container_port" {}

variable "public_subnets" {
  description = "Private subnets for ECS service"
  type        = list(string)
}