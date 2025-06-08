resource "aws_apprunner_service" "ars" {
  service_name = local.service_name

  source_configuration {
    authentication_configuration {
      access_role_arn = aws_iam_role.iamr.arn
    }

    image_repository {
      image_identifier      = var.source_configuration.image_repository.image_identifier
      image_repository_type = var.source_configuration.image_repository.image_repository_type

      image_configuration {
        port = var.source_configuration.image_repository.image_configuration.port
      }
    }

    auto_deployments_enabled = var.source_configuration.auto_deployments_enabled
  }

  tags = var.tags
}
