locals {
  cloudtrail_processor_lambda_name = "cloudtrail-processor"
}

resource "aws_lambda_function" "cloudtrail_processor" {
  function_name                  = local.cloudtrail_processor_lambda_name
  role                           = aws_iam_role.cloudtrail_processor.arn
  timeout                        = 120
  memory_size                    = 512
  reserved_concurrent_executions = 1
  runtime = "go1.x"
  handler = "main"
  s3_bucket = "dfds-iam-roles-anywhere-artifacts"
  s3_key = "${local.cloudtrail_processor_lambda_name}-lambda.zip"
  source_code_hash = data.aws_s3_object.cloudtrail_processor.etag

  environment {
    variables = {
      // TODO: set variables
      OBSERVABILITY_ROLE_ARN = var.observability_role_arn
      OBSERVABILITY_BUCKET = var.observability_bucket
      EVENTS_TO_LOG = join(", ", var.events_to_log)
    }
  }

  tracing_config {
    mode = "Active"
  }
}

data "aws_s3_object" "cloudtrail_processor" {
  bucket = "dfds-iam-roles-anywhere-artifacts"
  key    = "${local.cloudtrail_processor_lambda_name}-lambda.zip"
}

resource "aws_iam_role" "cloudtrail_processor" {
  name               = local.cloudtrail_processor_lambda_name
  assume_role_policy = data.aws_iam_policy_document.cloudtrail_processor_trust.json
}

data "aws_iam_policy_document" "cloudtrail_processor_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "cloudtrail_processor" {
  policy_arn = aws_iam_policy.cloudtrail_processor_access.arn
  role       = aws_iam_role.cloudtrail_processor.name
}

resource "aws_iam_policy" "cloudtrail_processor_access" {
  name        = "${local.cloudtrail_processor_lambda_name}-lambda-access"
  description = "Access policy for the ${local.cloudtrail_processor_lambda_name} lambda"
  policy      = data.aws_iam_policy_document.cloudtrail_processor_access.json
}

data "aws_iam_policy_document" "cloudtrail_processor_access" {
  statement {
    sid = "ClowudwatchAccess"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.cloudtrail_processor.arn}:*"
    ]
  }

  statement {
    sid = "AccessCloudtrailBucket"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = ["${module.cloudtrail_bucket.bucket_arn}/*"] // TODO: Access observability bucket
  }

  statement {
    sid = "KMSAccess"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt"
    ]
    resources = [aws_kms_key.cloudtrail.arn]
  }

  statement {
    sid = "AllowAssumeObservabilityRole"
    actions = ["sts:AssumeRole"]
    resources = [var.observability_role_arn]
  }
}

resource "aws_cloudwatch_log_group" "cloudtrail_processor" {
  name              = "/aws/lambda/${local.cloudtrail_processor_lambda_name}"
  retention_in_days = 0
}

resource "aws_lambda_permission" "cloudtrail_processor" {
  statement_id = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cloudtrail_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn = module.cloudtrail_bucket.bucket_arn
}

resource "aws_s3_bucket_notification" "cloudtrail_processor" {
  bucket = module.cloudtrail_bucket.bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.cloudtrail_processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "AWSLogs/"
    filter_suffix       = ".json.gz"
  }

  depends_on = [aws_lambda_permission.cloudtrail_processor]
}
