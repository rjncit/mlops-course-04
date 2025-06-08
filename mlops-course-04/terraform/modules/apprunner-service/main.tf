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
        runtime_environment_variables = {
          "PORT" = "80"
        }
      }
    }

    auto_deployments_enabled = var.source_configuration.auto_deployments_enabled
  }

  health_check_configuration {
    protocol            = "HTTP"
    path                = "/health"
    interval            = 30
    timeout             = 20
    healthy_threshold   = 2
    unhealthy_threshold = 5
  }

  instance_configuration {
    cpu    = "2048"
    memory = "4096"
  }

  network_configuration {
    egress_configuration {
      egress_type = "DEFAULT"
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "iamr" {
  name = "${local.service_name}-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "apprunner_ecr_access" {
  role       = aws_iam_role.iamr.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppRunnerServicePolicyForECRAccess"
}

resource "aws_iam_role_policy" "additional_permissions" {
  name = "apprunner-additional-permissions"
  role = aws_iam_role.iamr.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "apprunner" {
  name              = "/aws/apprunner/${local.service_name}"
  retention_in_days = 7
}