locals {
  cloudtrail_bucket_name = "dfds-${var.system_name}-rolesanywhere-trail"
  cloudtrail_name = "rolesanywhere"
}

data "aws_caller_identity" "current" {}

module "cloudtrail_bucket" {
  source = "git::https://github.com/dfds/aws-modules-s3.git?ref=fix_logging"

  bucket_name                     = local.cloudtrail_bucket_name
  bucket_versioning_configuration = "Enabled"
  object_ownership                = "BucketOwnerPreferred"
  create_policy                   = true

  //logging_bucket_name   = "dfds-iam-anywhere-private-ca-non-prod-s3-logs" //TODO: change
  source_policy_documents = [data.aws_iam_policy_document.cloudtrail.json]

  kms_key_arn = aws_kms_key.cloudtrail.arn
  // TODO: add lifecycle policy

  logging_bucket_name = "${local.cloudtrail_bucket_name}-logs"
  create_logging_bucket = true

}

data "aws_iam_policy_document" "cloudtrail" {
  statement {
    sid = "AllowCloudtrailACLCheck"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${local.cloudtrail_bucket_name}"]
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:eu-central-1:${data.aws_caller_identity.current.account_id}:trail/${local.cloudtrail_name}"]
      variable = "aws:SourceArn"
    }
  }

  statement {
    sid = "AllowCloudtrailWrite"
    effect = "Allow"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${local.cloudtrail_bucket_name}/*"]
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:eu-central-1:${data.aws_caller_identity.current.account_id}:trail/${local.cloudtrail_name}"]
      variable = "aws:SourceArn"
    }
  }
}

resource "aws_cloudtrail" "cloudtrail" {
  name           = local.cloudtrail_name
  s3_bucket_name = module.cloudtrail_bucket.bucket_name
  kms_key_id     = aws_kms_key.cloudtrail.arn
}

resource "aws_kms_key" "cloudtrail" {
  description = "KMS key for encrypting CloudTrail logs"
  deletion_window_in_days = 7
  key_usage = "ENCRYPT_DECRYPT"
  policy = data.aws_iam_policy_document.cloudtrail_kms.json
}

data "aws_iam_policy_document" "cloudtrail_kms" {
  statement {
    sid = "KeyAdmin"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }
  }

  statement {
    sid = "AllowCloudtrailEncrypt"
    principals {
      identifiers = ["cloudtrail.amazonaws.com"]
      type        = "Service"
    }
    actions = ["kms:GenerateDataKey*"]
    resources = ["*"]
    condition {
      test     = "StringLike"
      values   = ["arn:aws:cloudtrail:*:${data.aws_caller_identity.current.account_id}:trail/*"]
      variable = "kms:EncryptionContext:aws:cloudtrail:arn"
    }
    condition {
      test     = "StringEquals"
      values   = ["arn:aws:cloudtrail:eu-central-1:${data.aws_caller_identity.current.account_id}:trail/${local.cloudtrail_name}"]
      variable = "aws:SourceArn"
    }
  }

  statement {
    sid = "AllowLambdaDecrypt"
    actions = ["kms:Decrypt"]
    principals {
      identifiers = [aws_iam_role.cloudtrail_processor.arn]
      type        = "AWS"
    }
    resources = ["*"]
  }
}

// TODO: Lambda KMS access
