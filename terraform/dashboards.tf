resource "kestra_dashboard" "acme-dashboard" {
source_code = file("${path.module}/../resources/dashboards/execution_state.yaml")
}