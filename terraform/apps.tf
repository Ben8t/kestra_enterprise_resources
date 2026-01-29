resource "kestra_app" "acme-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/extract_weather.yaml")
}

resource "kestra_app" "acme-agent-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/acme_agent.yaml")
}

resource "kestra_app" "customer-onboarding-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/customer_onboarding.yaml")
}

resource "kestra_app" "invoice-processing-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/invoice_processing.yaml")
}

resource "kestra_app" "employee-onboarding-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/employee_onboarding.yaml")
}

resource "kestra_app" "order-fulfillment-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/order_fulfillment.yaml")
}

resource "kestra_app" "bug-report-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/bug_report.yaml")
}

resource "kestra_app" "email-campaign-app" {
  depends_on = [kestra_flow.flows]
  source      = file("${path.module}/../resources/apps/email_campaign.yaml")
}