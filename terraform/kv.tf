resource "kestra_kv" "kv" {
  key = "test"
  value = "test"
  namespace = kestra_namespace.acme.id
}

resource "kestra_kv" "tenant_id" {
  key = "KESTRA_TENANT_ID"
  value = var.kestra_tenant_id
  namespace = kestra_namespace.acme.id
}

resource "kestra_kv" "acme_base_url" {
  key = "KESTRA_BASE_URL"
  value = var.kestra_base_url
  namespace = kestra_namespace.acme.id
}