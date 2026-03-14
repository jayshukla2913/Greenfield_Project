resource "aws_ecs_cluster" "cluster" {

  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

}

# task definition
resource "aws_ecs_task_definition" "task" {

  family                   = "greenfield-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  network_mode             = "awsvpc"

  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "node-app"
      image     = "${var.ecr_repo_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true

      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
        }
      ]
            environment = [
        {
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "DB_USER"
          value = var.db_user
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        }
      ]
        logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
        }
    }
  ])
}

# service

resource "aws_ecs_service" "service" {

  name            = "greenfield-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {

    subnets         = var.private_subnets
    security_groups = [var.security_group]
    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = var.target_group_arn
    container_name   = "greenfield-app"
    container_port   = var.container_port

  }

}

# logging

resource "aws_cloudwatch_log_group" "ecs_logs" {

  name              = "/ecs/greenfield-app"
  retention_in_days = 7

}

# scaling

resource "aws_appautoscaling_target" "ecs_target" {

  max_capacity       = 4
  min_capacity       = 1

  resource_id = "service/${aws_ecs_cluster.cluster.name}/${aws_ecs_service.service.name}"

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

}

resource "aws_appautoscaling_policy" "cpu_policy" {

  name = "cpu-autoscaling"

  policy_type = "TargetTrackingScaling"

  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {

    target_value = 70

    predefined_metric_specification {

      predefined_metric_type = "ECSServiceAverageCPUUtilization"

    }

  }

}