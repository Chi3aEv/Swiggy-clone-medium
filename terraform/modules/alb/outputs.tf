output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb.id # Make sure your ALB SG resource is named "alb"
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green.arn
}