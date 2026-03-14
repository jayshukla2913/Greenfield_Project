output "alb_sg" {
  value = aws_security_group.alb_sg.id
}

output "ecs_sg" {
  value = aws_security_group.ecs_sg.id
}

output "rds_sg" {
  value = aws_security_group.rds_sg.id
}