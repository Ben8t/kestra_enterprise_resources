resource "kestra_service_account" "kestra-service-account" {
  name        = "kestra-service-account"
  description = "Kestra Service Account"
}

resource "kestra_service_account_api_token" "kestra-service-account-api-token" {
  name                = "kestra-service-account-api-token"
  description         = "Kestra Service Account API Token"
  service_account_id  = kestra_service_account.kestra-service-account.id
  max_age             = "P3D"
}

output "kestra_service_account_api_token" {
  description = "The API token for the Kestra service account"
  value       = kestra_service_account_api_token.kestra-service-account-api-token
  sensitive   = true
}