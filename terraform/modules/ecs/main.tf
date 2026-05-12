resource "aws_ecs_cluster" "main" {
  name = "swiggy-cluster"
}

resource "aws_ecs_service" "main" {
  name            = "swiggy-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  # This is the "Blue" environment starting point
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

  deployment_controller { type = "CODE_DEPLOY" } # Vital for Blue-Green
}


# 1. The Task Definition (The Blueprint)
resource "aws_ecs_task_definition" "app" {
  family                   = "swiggy-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn # We'll need to add this variable

  container_definitions = jsonencode([
    {
      name      = "swiggy-app"
      image     = "${var.repository_url}:latest" # We'll need this from the ECR module
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

# 2. Update your existing Service to use the correct name
# Ensure container_name here matches the "name" in container_definitions above
