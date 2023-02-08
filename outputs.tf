output "iam_profile_arn" {
  description = " IAM roles anywhere profile Arn"
  value       = aws_rolesanywhere_profile.this.arn
}

output "iam_role_arn" {
  description = " IAM role Arn"
  value       = aws_iam_role.this.arn
}

output "trust_anchor_arn" {
    value = aws_rolesanywhere_trust_anchor.this.arn
}