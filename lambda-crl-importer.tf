locals {
  lambda_name = var.crl_lambda_name
  bucket_name = data.aws_region.current.name == "eu-central-1" ? var.shared_lambda_bucket_name : "${var.shared_lambda_bucket_name}-${data.aws_region.current.name}"
}

resource "aws_lambda_function" "this" {
  function_name                  = local.lambda_name
  role                           = aws_iam_role.lambda.arn
  timeout                        = 120
  memory_size                    = 512
  reserved_concurrent_executions = 1
  runtime = "provided.al2"
  handler = "bootstrap"
  s3_bucket = local.bucket_name
  s3_key = "${data.aws_s3_object.this.key}"
  source_code_hash = data.aws_s3_object.this.etag

  environment {
    variables = {
      CRL_NAME = var.crl_name
      CRL_URL         = var.crl_url
      TRUST_ANCHOR_ARN = aws_rolesanywhere_trust_anchor.this.arn
    }
  }

  tracing_config {
    mode = "Active"
  }

}

data "aws_s3_object" "this" {
  bucket = local.bucket_name
  key    = "${var.crl_lambda_path}${var.crl_shared_lambda_name}-lambda.zip"
}

resource "aws_iam_role" "lambda" {
  name               = local.lambda_name
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
}

data "aws_iam_policy_document" "lambda_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = aws_iam_policy.lambda_access.arn
  role       = aws_iam_role.lambda.name
}

resource "aws_iam_policy" "lambda_access" {
  name        = "${local.lambda_name}-lambda-access"
  description = "Access policy for the ${local.lambda_name} lambda"
  policy      = data.aws_iam_policy_document.lambda_access.json
}

data "aws_iam_policy_document" "lambda_access" {
  statement {
    sid = "ClowudwatchAccess"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.lambda.arn}:*"
    ]
  }

  statement {
    sid = "AccessRolesAnywhere"
    actions = [
      "rolesanywhere:ListCrls",
      "rolesanywhere:EnableCrl",
      "rolesanywhere:ImportCrl",
      "rolesanywhere:UpdateCrl"
    ]
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.lambda_name}"
  retention_in_days = 0
}

resource "aws_cloudwatch_event_rule" "this" {
  name = "run-${local.lambda_name}-lambda"

  description = "Run ${local.lambda_name} lambda once a day"
  schedule_expression = "cron(0/60 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "this" {
  arn = aws_lambda_function.this.arn
  rule = aws_cloudwatch_event_rule.this.id
}

resource "aws_lambda_permission" "this" {
  statement_id = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.this.arn
}
