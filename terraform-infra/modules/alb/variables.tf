variable "vpc_id" {
  description = "VPC ID for ALB"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets for ALB"
  type        = list(string)
}

variable "alb_sg" {
  description = "Security group for ALB"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}