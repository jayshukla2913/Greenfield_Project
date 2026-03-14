variable "cluster_name" {}
variable "target_group_arn" {}
variable "security_group" {}
variable "container_port" {}

variable "public_subnets" {
  description = "Public subnets for ECS service"
  type        = list(string)
}

variable "ecr_repository_url" {
  description = "ECR repository URL"
  type        = string
}

variable "execution_role_arn" {
  description = "ECS task execution role ARN"
  type        = string
}