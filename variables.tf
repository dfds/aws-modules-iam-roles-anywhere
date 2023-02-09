variable "system_name" {
  type        = string
  description = "Name of the application of service to be used with IAM Roles Anywhere"
}

variable "system_environment" {
  type        = string
  description = "(optional) System Environment"
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
    action   = string
    resource = string
  }))
  default = []
}