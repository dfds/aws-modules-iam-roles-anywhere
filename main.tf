provider "aws" {
    default_tags {
        tags = {
          Environment = var.system_environment
          System_name = var.system_name
        }
      }
  }

resource "aws_iam_role" "this" {
  name = var.system_name + "-role"
  assume_role_policy = data.aws_iam_policy_document.role_trust_relationship.json
}

resource "aws_rolesanywhere_profile" "this" {
  name      = var.system_name + "-profile"
  enabled   = true
  role_arns = [aws_iam_role.this.arn]
}

resource "aws_rolesanywhere_trust_anchor" "this" {
  name = var.system_name + "-trust-anchor"
  enabled   = true
  source {
    source_data {
      acm_pca_arn = var.aws_private_ca_arn
    }
    source_type = "AWS_ACM_PCA"
  }
}