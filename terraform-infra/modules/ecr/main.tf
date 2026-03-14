resource "aws_ecr_repository" "app" {

  name = "greenfield-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  force_delete = true
}

output "repository_url" {
  value = aws_ecr_repository.app.repository_url
}