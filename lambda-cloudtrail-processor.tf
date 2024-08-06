module "cloudtrail_processor" {
#   source = "s3::https://dfds-ce-shared-artifacts.s3.eu-central-1.amazonaws.com/IAM-Roles-Anywhere-PCA-Observability/observability-cloudtrail-processor-lambda-1.4.0.zip"
  source = "../IAM-Roles-Anywhere-PCA-Observability/observability-cloudtrail-processor-lambda"
  providers = {
    aws = aws
  }

  system_name            = var.system_name
  observability_role_arn = var.observability_role_arn
}
