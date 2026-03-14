variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "ecs_security_group" {
  description = "ECS security group ID"
  type        = string
}