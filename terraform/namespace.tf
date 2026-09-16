resource "kestra_namespace" "acme" {
  namespace_id = "acme"
  description  = "Base Acme Namespace"
  # Plugin defaults moved to kestra_policy.acme_git_credentials (policies.tf).
}

resource "kestra_namespace" "acme_weather" {
  namespace_id = "acme.weather"
  description  = "Weather Namespace"
  # Retry defaults moved to kestra_policy.acme_weather_retries (policies.tf).
  depends_on = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_local" {
  namespace_id = "acme.local"
  description  = "Local Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_sales" {
  namespace_id = "acme.sales"
  description  = "Sales Department Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_marketing" {
  namespace_id = "acme.marketing"
  description  = "Marketing Department Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_finance" {
  namespace_id = "acme.finance"
  description  = "Finance Department Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_hr" {
  namespace_id = "acme.hr"
  description  = "Human Resources Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_operations" {
  namespace_id = "acme.operations"
  description  = "Operations Department Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_product" {
  namespace_id = "acme.product"
  description  = "Product Team Namespace"
  depends_on   = [kestra_namespace.acme]
}

resource "kestra_namespace" "acme_training" {
  namespace_id = "acme.training"
  description  = "Training Namespace"
  depends_on   = [kestra_namespace.acme]
}