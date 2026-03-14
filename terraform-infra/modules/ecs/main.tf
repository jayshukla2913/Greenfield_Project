resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "task" {
  family                   = "greenfield-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "app"
      image = "greenfield-app:latest"
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "greenfield-ecs-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }

  network_configuration {
    security_groups = [var.security_group]
    subnets         = var.public_subnets
  }
}