# Governance policies (Kestra 2.0 EE) — the replacement for `pluginDefaults`.
#
# Each policy is TENANT scope and narrowed to a namespace subtree via
# `target.namespaces`. `Add` rules inject values when the task does not set
# them (like the old forced: false defaults); `where` matches the plugin type
# by prefix, exactly as the old defaults did.

# Git token for every plugin-git task under acme (was the acme namespace default).
resource "kestra_policy" "acme_git_credentials" {
  scope     = "TENANT"
  policy_id = "acme-git-credentials"
  content   = <<EOT
id: acme-git-credentials
displayName: Acme Git credentials
enforcement: ACTIVE
target:
  namespaces: [acme]
rules:
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    where:
      - { field: type, operator: STARTS_WITH, value: io.kestra.plugin.git }
    values:
      password: "{{ secret('GITHUB_TOKEN') }}"
EOT

  depends_on = [kestra_namespace.acme]
}

# Exponential retries for HTTP and DuckDB tasks (was the acme.weather namespace default).
resource "kestra_policy" "acme_weather_retries" {
  scope     = "TENANT"
  policy_id = "acme-weather-retries"
  content   = <<EOT
id: acme-weather-retries
displayName: Weather retries
enforcement: ACTIVE
target:
  namespaces: [acme.weather]
rules:
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    where:
      - { field: type, operator: REGEX, value: 'io\.kestra\.plugin\.(core\.http|jdbc\.duckdb)\..*' }
    values:
      retry:
        type: exponential
        interval: PT5S
        maxInterval: PT1M
        maxAttempts: 3
EOT

  depends_on = [kestra_namespace.acme_weather]
}

# Connection defaults for the acme.company.* flows (were flow-level pluginDefaults).
resource "kestra_policy" "acme_company_defaults" {
  scope     = "TENANT"
  policy_id = "acme-company-defaults"
  content   = <<EOT
id: acme-company-defaults
displayName: Acme company connection defaults
enforcement: ACTIVE
target:
  namespaces: [acme.company]
rules:
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    where:
      - { field: type, operator: STARTS_WITH, value: io.kestra.plugin.aws }
    values:
      accessKeyId: "{{ secret('AWS_ACCESS_KEY') }}"
      secretKeyId: "{{ secret('AWS_SECRET_ACCESS_KEY') }}"
      region: "{{ secret('AWS_REGION') }}"
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    where:
      - { field: type, operator: STARTS_WITH, value: io.kestra.plugin.jdbc.duckdb }
    values:
      url: "jdbc:duckdb:md:my_db?motherduck_token={{ secret('MOTHERDUCK_TOKEN') }}"
      fetchType: STORE
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    where:
      - { field: type, operator: STARTS_WITH, value: io.kestra.plugin.jdbc.sqlite }
    values:
      url: jdbc:sqlite:myfile.db
      fetchType: NONE
EOT

  depends_on = [kestra_namespace.acme]
}

# Guardrail: no raw shell tasks in the training namespace.
resource "kestra_policy" "acme_training_no_shell" {
  scope     = "TENANT"
  policy_id = "acme-training-no-shell"
  content   = <<EOT
id: acme-training-no-shell
displayName: No raw shell in training
enforcement: ACTIVE
target:
  namespaces: [acme.training]
rules:
  - type: io.kestra.plugin.ee.rules.Deny
    on: PLUGIN
    where:
      - { field: type, operator: STARTS_WITH, value: io.kestra.plugin.scripts.shell }
    errorMessage: "Raw shell tasks are not allowed in acme.training; use a Python or Docker task."
EOT

  depends_on = [kestra_namespace.acme_training]
}

# Tenant-wide guardrail: every runnable task times out after 60 seconds (forced,
# so a task cannot opt out with a longer value). PLUGIN rules also see triggers,
# asset declarations, AI providers and task runners, none of which accept
# `timeout`, and flowable tasks (io.kestra.plugin.core.flow.*) only warn about
# it; the `where` keeps all of those out.
resource "kestra_policy" "task_timeout" {
  scope     = "TENANT"
  policy_id = "task-timeout-60s"
  content   = <<EOT
id: task-timeout-60s
displayName: Task timeout 60s
enforcement: ACTIVE
rules:
  - type: io.kestra.plugin.ee.rules.Add
    on: PLUGIN
    override: true
    where:
      - { field: id, operator: IS_NOT_NULL }
      - { field: type, operator: REGEX, value: '^(?!.*\.(trigger|assets|core\.flow)\.)(?!.*\.Trigger$)io\.kestra\..*$' }
    values:
      timeout: PT1M
EOT
}
