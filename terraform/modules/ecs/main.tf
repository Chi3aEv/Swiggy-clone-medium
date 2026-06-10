# CloudWatch Log Group — must exist before ECS starts
resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/swiggy-app"
  retention_in_days = 7
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "swiggy-cluster"
}

# Task Definition
resource "aws_ecs_task_definition" "app" {
  family                   = "swiggy-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "swiggy-app"
      image     = "${var.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/swiggy-app"
          "awslogs-region"        = "ap-south-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "main" {
  name            = "swiggy-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "swiggy-app"
    container_port   = 80
  }

  network_configuration {
    subnets          = var.subnets
    security_groups  = [var.security_group]
    assign_public_ip = true
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  depends_on = [aws_cloudwatch_log_group.ecs]

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

# Outputs
output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "service_name" {
  value = aws_ecs_service.main.name
}