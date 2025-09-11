resource "kestra_app" "kestra-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/extract_weather.yaml")
}

resource "kestra_app" "kestra-agent-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/kestra_agent.yaml")
}