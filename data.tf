data "aws_iam_policy_document" "role_trust_relationship" {
  statement {
    sid = "1"

    effect = "Allow"
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
}

data "aws_iam_policy_document" "role_policy" {
  dynamic "statement" {
    for_each = var.iam_role_actions
    iterator = i
    content {
      effect    = "Allow"
      actions   = i.value["actions"]
      resources = length(i.value["resources"]) > 0 ? i.value["resources"] : []
    }
  }
}