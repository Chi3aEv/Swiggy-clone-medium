resource "aws_lb" "main" {
  name               = "swiggy-alb"
  load_balancer_type = "application"
  subnets            = var.subnets
  security_groups    = [aws_security_group.alb.id]
}

# Blue Target Group (Production)
resource "aws_lb_target_group" "blue" {
  name     = "tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

# Green Target Group (Test)
resource "aws_lb_target_group" "green" {
  name     = "tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
}

# Prod Listener
resource "aws_lb_listener" "prod" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}

resource "aws_security_group" "alb" {
  name        = "swiggy-alb-sg"
  description = "Allow HTTP inbound traffic"
  vpc_id      = var.vpc_id

  # Production traffic
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Blue-Green Testing traffic
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ... keep your existing aws_lb and aws_lb_target_group resources below ...
