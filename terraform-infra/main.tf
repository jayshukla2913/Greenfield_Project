module "vpc" {
  source = "./modules/vpc"

  cidr_block = "10.0.0.0/16"
  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]

}

module "security" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  security_group = module.security.aws_security_group.alb_sg
}

module "ecr" {
  source = "./modules/ecr"
}

module "alb" {
  source = "./modules/alb"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  alb_sg          = module.security.alb_sg
  container_port  = var.container_port
}

module "ecs" {

  source = "./modules/ecs"

  cluster_name    = "production-cluster"
  private_subnets = module.vpc.private_subnets
  security_group  = module.security.app_sg

  target_group_arn = module.alb.target_group_arn

  container_port = 3000

  ecr_repo_url = module.ecr.repository_url

  db_host     = module.rds.db_endpoint
  db_name     = module.rds.db_name
  db_user     = var.db_username
  db_password = var.db_password

}

module "rds" {

  source = "./modules/rds"

  vpc_id            = module.vpc.vpc_id
  private_subnets   = module.vpc.private_subnets
  security_group = module.security.app_sg

  db_username = var.db_username
  db_password = var.db_password

}