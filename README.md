# aws-modules-iam-roles-anywhere
IAM Roles Anywhere allows your workloads such as servers, containers, and applications to use X.509 digital certificates to obtain temporary AWS credentials

# Documentation
<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.31.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.54.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |
| [aws_cloudwatch_log_group.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_policy.lambda_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lambda_function.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) | resource |
| [aws_lambda_permission.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) | resource |
| [aws_rolesanywhere_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_profile) | resource |
| [aws_rolesanywhere_trust_anchor.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/rolesanywhere_trust_anchor) | resource |
| [aws_iam_policy_document.lambda_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lambda_trust](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.role_trust_relationship](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_object) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_crl_lambda_name"></a> [crl\_lambda\_name](#input\_crl\_lambda\_name) | Name of the shared lambda function that will be used to check the CRL | `string` | `"crl-importer"` | no |
| <a name="input_crl_lambda_path"></a> [crl\_lambda\_path](#input\_crl\_lambda\_path) | Path to the shared lambda function inside the shared lambda bucket that will be used to check the CRL, make sure to include the trailing slash | `string` | `"iam-rolesanywhere-lambdas/"` | no |
| <a name="input_crl_name"></a> [crl\_name](#input\_crl\_name) | Name of the certificate revocation list (CRL) | `string` | n/a | yes |
| <a name="input_crl_shared_lambda_name"></a> [crl\_shared\_lambda\_name](#input\_crl\_shared\_lambda\_name) | Name of the shared lambda function zip file in the shared bucket in the shared bucket that will be used to check the CRL | `string` | `"crl-importer"` | no |
| <a name="input_crl_url"></a> [crl\_url](#input\_crl\_url) | URL of the certificate revocation list (CRL) | `string` | n/a | yes |
| <a name="input_iam_role_actions"></a> [iam\_role\_actions](#input\_iam\_role\_actions) | Actions and the corresponding resource that are allowed to be actioned on by the assumed role | <pre>list(object({<br>    actions   = list(string)<br>    resources = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_shared_lambda_bucket_name"></a> [shared\_lambda\_bucket\_name](#input\_shared\_lambda\_bucket\_name) | Name of the S3 bucket where the shared lambda functions are stored | `string` | `"dfds-rf-ce-shared-artifacts"` | no |
| <a name="input_system_environment"></a> [system\_environment](#input\_system\_environment) | System Environment | `string` | `""` | no |
| <a name="input_system_name"></a> [system\_name](#input\_system\_name) | Name of the application of service to be used with IAM Roles Anywhere | `string` | n/a | yes |
| <a name="input_x509_certificate_data"></a> [x509\_certificate\_data](#input\_x509\_certificate\_data) | Bundled Certificate x509 Certificate Data | `string` | n/a | yes |
| <a name="input_x509_subject_cn_values"></a> [x509\_subject\_cn\_values](#input\_x509\_subject\_cn\_values) | List of the values of approved certificate CN's | `list(string)` | n/a | yes |
| <a name="input_x509_subject_ou_values"></a> [x509\_subject\_ou\_values](#input\_x509\_subject\_ou\_values) | List of the values of certificate OU's | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_iam_profile_arn"></a> [iam\_profile\_arn](#output\_iam\_profile\_arn) | The Arn of the aws iam role anywhere profile |
| <a name="output_iam_role_arn"></a> [iam\_role\_arn](#output\_iam\_role\_arn) | The Arn of the aws iam role |
| <a name="output_trust_anchor_arn"></a> [trust\_anchor\_arn](#output\_trust\_anchor\_arn) | The Arn of the aws iam role anywhere trust anchor |
<!-- END_TF_DOCS -->
