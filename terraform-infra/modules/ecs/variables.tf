variable "cluster_name" {}
variable "private_subnets" {}
variable "security_group" {}
variable "target_group_arn" {}
variable "container_port" {}

variable "ecr_repo_url" {}

variable "db_host" {}
variable "db_name" {}
variable "db_user" {}
variable "db_password" {}

variable "aws_region" {
  default = "us-east-1"
}