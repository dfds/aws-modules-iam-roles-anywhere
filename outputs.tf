output "iam_profile_arn" {
  description = "The Arn of the aws iam role anywhere profile"
  value       = aws_rolesanywhere_profile.this.arn
}

output "iam_role_arn" {
  description = "The Arn of the aws iam role"
  value       = aws_iam_role.this.arn
}

output "trust_anchor_arn" {
  description = "The Arn of the aws iam role anywhere trust anchor"
  value       = aws_rolesanywhere_trust_anchor.this.arn
}
