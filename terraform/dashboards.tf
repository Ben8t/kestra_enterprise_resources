resource "kestra_dashboard" "kestra-dashboard" {
source_code = file("${path.module}/../resources/dashboards/execution_state.yaml")
}