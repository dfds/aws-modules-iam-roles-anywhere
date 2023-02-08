variable "system_name" {
    type = string
    description = "Name of the application of service to be used with IAM Roles Anywhere"
}

variable "system_environment" {
    type = string
    description = "(optional) System Environment"
    default = ""
}

variable "aws_private_ca_arn" {
    type = string
    description = "Arn of the aws private CA that will be used"
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
        action = string
        resource = string
    }))
    default = []
}