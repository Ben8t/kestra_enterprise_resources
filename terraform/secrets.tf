
resource "kestra_namespace_secret" "github_token" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "GITHUB_TOKEN"
  secret_value = var.github_token
  depends_on   = [kestra_namespace.acme]
}


resource "kestra_namespace_secret" "openai_api_key" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "OPENAI_API_KEY"
  secret_value = var.openai_api_key
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "kestra_username" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "KESTRA_USERNAME"
  secret_value = var.kestra_username
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "kestra_password" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "KESTRA_PASSWORD"
  secret_value = var.kestra_password
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "resend_api_key" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "RESEND_API_KEY"
  secret_value = var.resend_api_key
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "aws_access_key" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "AWS_ACCESS_KEY"
  secret_value = var.aws_access_key
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "aws_secret_access_key" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "AWS_SECRET_ACCESS_KEY"
  secret_value = var.aws_secret_access_key
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "aws_region" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "AWS_REGION"
  secret_value = var.aws_region
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "aws_s3_bucket" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "AWS_S3_BUCKET"
  secret_value = var.aws_s3_bucket
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace_secret" "motherduck_token" {
  namespace    = kestra_namespace.acme.id
  secret_key   = "MOTHERDUCK_TOKEN"
  secret_value = var.motherduck_token
  depends_on   = [kestra_namespace.acme]
}