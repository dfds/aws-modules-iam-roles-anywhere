data "aws_iam_policy_document" "role_trust_relationship" {
  statement {
    sid = "1"

    effect  = "Allow"
    actions = [
        "sts:AssumeRole",
        "sts:TagSession",
        "sts:SetSourceIdentity"
    ]

    principals {
      identifiers = ["rolesanywhere.amazonaws.com"]
      type        = "Service"
    }

    condition {
      test     = "StringEquals"
      values   = var.x509_subject_ou_values
      variable = "aws:PrincipalTag/x509Subject/OU"
    }

    condition {
      test     = "StringEquals"
      values   = var.x509_subject_cn_values
      variable = "aws:PrincipalTag/x509Subject/CN"
    }
  }

  dynamic "statement" {
      for_each = var.iam_role_actions
      content {
        effect = "Allow"
        actions = [statement.value["action"]]
        resources = [statement.value["resource"] != "" ? statement.value["resource"] : ""]
      }
  }
}