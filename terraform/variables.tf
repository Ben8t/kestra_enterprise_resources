variable "kestra_user" {
  type      = string
  sensitive = true
}


variable "github_token" {
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

# New variables for Docker Compose integration
variable "postgres_db" {
  type      = string
  sensitive = true
}

variable "postgres_user" {
  type      = string
  sensitive = true
}

variable "postgres_password" {
  type      = string
  sensitive = true
}

variable "kestra_encryption_secret_key" {
  type      = string
  sensitive = true
}

variable "kestra_jdbc_secret" {
  type      = string
  sensitive = true
}

variable "kestra_license_id" {
  type      = string
  sensitive = true
}

variable "kestra_license_fingerprint" {
  type      = string
  sensitive = true
}

variable "kestra_license_key" {
  type      = string
  sensitive = true
}

variable "resend_api_key"{
  type = string
  sensitive = true
}

variable "aws_access_key" {
  type = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type = string
  sensitive = true
}

variable "aws_region" {
  type = string
  sensitive = true
}

variable "aws_s3_bucket" {
  type = string
  sensitive = true
}

variable "motherduck_token" {
  type = string
  sensitive = true
}