terraform {
  backend "s3" {
  }
}

provider "aws" {
  default_tags {
    tags = {
      Environment = var.system_environment
      System_name = var.system_name
    }
  }
}

resource "aws_iam_role" "this" {
  name               = "${var.system_name}-role"
  assume_role_policy = data.aws_iam_policy_document.role_trust_relationship.json
  inline_policy {
    name   = "${var.system_name}-policy"
    policy = data.aws_iam_policy_document.role_policy.json
  }
}

resource "aws_rolesanywhere_profile" "this" {
  name      = "${var.system_name}-profile"
  enabled   = true
  role_arns = [aws_iam_role.this.arn]
}

resource "aws_rolesanywhere_trust_anchor" "this" {
  name    = "${var.system_name}-trust-achor"
  enabled = true
  source {
    source_data {
      x509_certificate_data = var.x509_certificate_data
    }
    source_type = "CERTIFICATE_BUNDLE"
  }
}