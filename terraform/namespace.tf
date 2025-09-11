resource "kestra_namespace" "kestra" {
  namespace_id    = "kestra"
  description     = "Base Kestra Namespace"
  plugin_defaults = <<EOT
- type: io.kestra.plugin.git
  values:
    password: "{{ secret('GITHUB_TOKEN') }}"
EOT
}

resource "kestra_namespace" "kestra_weather" {
  namespace_id    = "kestra.weather"
  description     = "Weather Namespace"
  depends_on   = [kestra_namespace.kestra]
}