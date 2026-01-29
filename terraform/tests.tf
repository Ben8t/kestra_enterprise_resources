resource "kestra_test" "test" {
  depends_on = [kestra_flow.flows]
  test_id    = "test-extract"
  content    = file("${path.module}/../resources/tests/test-extract.yaml")
  namespace  = "acme.weather"
}