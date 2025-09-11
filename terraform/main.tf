terraform {
  required_providers {
    kestra = {
      source  = "kestra-io/kestra" # namespace of Kestra provider
      version = "~> 1.0.0"        # version of Kestra Terraform provider, not the version of Kestra
    }
  }
}

provider "kestra" {
  url      = "http://localhost:8080"
  username = var.kestra_user
  password = var.kestra_password
  tenant_id   = "main"
}


resource "kestra_flow" "flows" {
  for_each  = fileset(path.module, "../resources/flows/*.yaml")
  flow_id   = yamldecode(templatefile(each.value, {}))["id"]
  namespace = yamldecode(templatefile(each.value, {}))["namespace"]
  content   = templatefile(each.value, {})
}
