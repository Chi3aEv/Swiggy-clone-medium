provider "aws" {
  region = "ap-south-1"
}

module "networking" { source = "./modules/networking" }
module "ecr"        { source = "./modules/ecr" }
module "iam"        { source = "./modules/iam" }

module "alb" {
  source    = "./modules/alb"
  vpc_id    = module.networking.vpc_id
  subnets   = module.networking.public_subnets
}

module "ecs" {
  source           = "./modules/ecs"
  vpc_id           = module.networking.vpc_id
  subnets          = module.networking.public_subnets
  target_group_arn = module.alb.blue_target_group_arn
  security_group   = module.alb.alb_sg_id


  repository_url     = module.ecr.repository_url
  execution_role_arn = module.iam.ecs_task_execution_role_arn
}
