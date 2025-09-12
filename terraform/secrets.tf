
resource "kestra_namespace_secret" "github_token" {
  namespace    = kestra_namespace.kestra.id
  secret_key   = "GITHUB_TOKEN"
  secret_value = var.github_token
  depends_on   = [kestra_namespace.kestra]
}


resource "kestra_namespace_secret" "openai_api_key" {
  namespace    = kestra_namespace.kestra.id
  secret_key   = "OPENAI_API_KEY"
  secret_value = var.openai_api_key
  depends_on   = [kestra_namespace.kestra]
}

resource "kestra_namespace_secret" "kestra_username" {
  namespace    = kestra_namespace.kestra.id
  secret_key   = "KESTRA_USERNAME"
  secret_value = var.kestra_username
  depends_on   = [kestra_namespace.kestra]
}

resource "kestra_namespace_secret" "kestra_password" {
  namespace    = kestra_namespace.kestra.id
  secret_key   = "KESTRA_PASSWORD"
  secret_value = var.kestra_password
  depends_on   = [kestra_namespace.kestra]
}