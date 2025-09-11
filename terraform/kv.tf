resource "kestra_kv" "kv" {
  key = "test"
  value = "test"
  namespace = kestra_namespace.kestra.id
}
