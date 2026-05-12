variable "vpc_id" {
  description = "The VPC ID where ECS will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The ARN of the Blue Target Group"
  type        = string
}

variable "security_group" {
  description = "The Security Group ID for the ECS service"
  type        = string
}

variable "execution_role_arn" {
  type = string
}

variable "repository_url" {
  type = string
}

