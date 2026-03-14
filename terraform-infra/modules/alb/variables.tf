variable "vpc_id" {
  type = string
  default = module.vpc.aws_vpc.main.id
}

variable "public_subnets" {
    type = list(string)
    default = [module.vpc.aws_subnet.public1.id, module.vpc.aws_subnet.public2.id]
}

variable "alb_sg" {
  description = "Security group for ALB"
  type        = string
  default     = module.security.aws_security_group.alb_sg.id
}

variable "container_port" {
  description = "Port on which container listens"
  type        = number
  default     = 3000
}