module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]
}

module "security" {
  source = "./modules/security"

  vpc_id         = module.vpc.vpc_id
  container_port = var.container_port
}

module "alb" {
  source = "./modules/alb"

  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg = module.security.alb_sg
  container_port  = var.container_port
}

module "ecs" {
  source = "./modules/ecs"
  public_subnets  = module.vpc.public_subnets
  cluster_name     = "greenfield-cluster"
  target_group_arn = module.alb.target_group_arn
  security_group  = module.security.ecs_sg
  container_port   = var.container_port
}

module "rds" {
  source = "./modules/rds"

  private_subnets = module.vpc.private_subnets
  security_group  = module.security.rds_sg

  db_username = var.db_username
  db_password = var.db_password
}

module "ecr" {
  source = "./modules/ecr"
}