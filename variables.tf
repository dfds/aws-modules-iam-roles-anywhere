variable "system_name" {
  type        = string
  description = "Name of the application of service to be used with IAM Roles Anywhere"
}

variable "system_environment" {
  type        = string
  description = "System Environment"
  default     = ""
}

variable "x509_certificate_data" {
  type        = string
  description = "Bundled Certificate x509 Certificate Data"
}

variable "x509_subject_ou_values" {
  type        = list(string)
  description = "List of the values of certificate OU's"
}

variable "x509_subject_cn_values" {
  type        = list(string)
  description = "List of the values of approved certificate CN's"
}

variable "iam_role_actions" {
  description = "Actions and the corresponding resource that are allowed to be actioned on by the assumed role"
  type = list(object({
    actions   = list(string)
    resources = list(string)
  }))
  default = []
}

variable "crl_name" {
  type        = string
  description = "Name of the certificate revocation list (CRL)"
}

variable "crl_url" {
  type        = string
  description = "URL of the certificate revocation list (CRL)"
  validation {
    condition     = startswith(var.crl_url, "https://")
    error_message = "The URL must include `https://`."
  }
}

variable "crl_lambda_name" {
  type        = string
  description = "Name of the shared lambda function that will be used to check the CRL"
  default     = "crl-importer"
}

variable "crl_lambda_path" {
  type        = string
  description = "Path to the shared lambda function inside the shared lambda bucket that will be used to check the CRL, make sure to include the trailing slash"
  default     = "iam-rolesanywhere-lambdas/"
}

variable "shared_lambda_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where the shared lambda functions are stored"
  default     = "dfds-ce-shared-artifacts"
}

variable "crl_shared_lambda_name" {
  type        = string
  description = "Name of the shared lambda function zip file in the shared bucket in the shared bucket that will be used to check the CRL"
  default     = "crl-importer"
}

variable "deploy_cloudtrail_processor" {
  type        = bool
  description = "Whether to deploy the cloudtrail-processor lambda"
  default     = true
}

variable "observability_role_arn" {
  type        = string
  description = "AWS arn of the role that the lambda will assume in the account to place the logs in the bucket."
  default     = ""
}
