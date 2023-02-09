# aws-modules-iam-roles-anywhere
IAM Roles Anywhere allows your workloads such as servers, containers, and applications to use X.509 digital certificates to obtain temporary AWS credentials

# Documentation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.50.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.53.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_rolesanywhere_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_profile) | resource |
| [aws_rolesanywhere_trust_anchor.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_trust_anchor) | resource |
| [aws_iam_policy_document.role_trust_relationship](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_iam_role_actions"></a> [iam\_role\_actions](#input\_iam\_role\_actions) | Actions and the corresponding resource that are allowed to be actioned on by the assumed role | <pre>list(object({<br>    action   = string<br>    resource = string<br>  }))</pre> | `[]` | no |
| <a name="input_system_environment"></a> [system\_environment](#input\_system\_environment) | (optional) System Environment | `string` | `""` | no |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | Name of the application of service to be used with IAM Roles Anywhere | `string` | n/a | yes |
| <a name="input_x509_certificate_data"></a> [x509\_certificate\_data](#input\_x509\_certificate\_data) | Bundled Certificate x509 Certificate Data | `string` | n/a | yes |
| <a name="input_x509_subject_cn_values"></a> [x509\_subject\_cn\_values](#input\_x509\_subject\_cn\_values) | List of the values of approved certificate CN's | `list(string)` | n/a | yes |
| <a name="input_x509_subject_ou_values"></a> [x509\_subject\_ou\_values](#input\_x509\_subject\_ou\_values) | List of the values of certificate OU's | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_profile_arn"></a> [iam\_profile\_arn](#output\_iam\_profile\_arn) | IAM roles anywhere profile Arn |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | IAM role Arn |
| <a name="output_trust_anchor_arn"></a> [trust\_anchor\_arn](#output\_trust\_anchor\_arn) | n/a |
<!-- END_TF_DOCS -->
