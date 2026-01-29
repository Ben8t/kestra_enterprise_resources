resource "kestra_service_account" "acme-service-account" {
  name        = "acme-service-account"
  description = "Acme Service Account"
}

resource "kestra_service_account_api_token" "acme-service-account-api-token" {
  name                = "acme-service-account-api-token"
  description         = "Acme Service Account API Token"
  service_account_id  = kestra_service_account.acme-service-account.id
  max_age             = "P3D"
}

output "acme_service_account_api_token" {
  description = "The API token for the Acme service account"
  value       = kestra_service_account_api_token.acme-service-account-api-token
  sensitive   = true
}