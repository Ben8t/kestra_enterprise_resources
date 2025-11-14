resource "kestra_role" "example" {
  name        = "Friendly name"
  description = "Friendly description"

  permissions {
    type        = "FLOW"
    permissions = ["READ", "UPDATE"]
  }

  permissions {
    type        = "EXECUTION"
    permissions = ["READ", "UPDATE"]
  }
}

resource "kestra_group" "example" {
  name        = "Friendly name"
  description = "Friendly description"
}

resource "kestra_binding" "example" {
  type        = "GROUP"
  external_id = kestra_group.example.id
  role_id     = kestra_role.example.id
}

resource "kestra_user" "example" {
  email       = "john@doe.com"
  namespace   = "company.team"
  description = "Friendly description"
  first_name  = "John"
  last_name   = "Doe"
  groups      = [kestra_group.example.id]
}

