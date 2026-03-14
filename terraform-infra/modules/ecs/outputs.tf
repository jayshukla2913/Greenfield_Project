output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "service_name" {
  value = aws_ecs_service.service.name
}

variable "private_subnets" {
  description = "Private subnets for ECS service"
  type        = list(string)
}