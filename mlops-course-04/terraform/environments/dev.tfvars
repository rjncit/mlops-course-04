
environment = "dev"
aws_region  = "eu-west-1"


s3_buckets = [
  {
    key  = "mlops-course-ehb-datastore9129"
    tags = {}
  }
]

ecr_repositories = [
  {
    key                  = "mlops-course-ehb-repository9129"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration = {
      scan_on_push = true
    }
    tags = {}
  }
]

apprunner_services = [
  {
    key = "mlops-course-ehb-app9129"
    source_configuration = {
      image_repository = {
        image_identifier      = "331135961676.dkr.ecr.eu-west-1.amazonaws.com/ecr-mlops-course-ehb-repository9129-dev@sha256:8a2a42f55f4aaa73754f480bcc9638ec5def086a859000cd42e4ead1640c6de3"
        image_repository_type = "ECR"
        image_configuration = {
          port = 80
        }
      }
      auto_deployments_enabled = true
    }
    tags = {}
  }
]
