variable "kestra_user" {
  type      = string
  sensitive = true
}

variable "aws_key" {
  type      = string
  sensitive = true
}

variable "aws_secret" {
  type      = string
  sensitive = true
}

variable "slack_webhook" {
  type      = string
  sensitive = true
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "resend_api" {
  type      = string
  sensitive = true
}

variable "openai_api_key" {
  type      = string
  sensitive = true
}

variable "kestra_base_url" {
  type      = string
}

variable "kestra_tenant_id" {
  type      = string
}

variable "kestra_username" {
  type      = string
}

variable "kestra_password" {
  type      = string
}