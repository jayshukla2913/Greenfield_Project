terraform {
  required_version = ">=1.5"

  backend "s3" {
    bucket         = "greenfield-terraform-state-bucket"
    key            = "greenfield-project/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}