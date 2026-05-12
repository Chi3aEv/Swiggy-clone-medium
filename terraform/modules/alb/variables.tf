variable "vpc_id" {
  description = "The VPC ID where ECS will be deployed"
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs for the ECS service"
  type        = list(string)
}


