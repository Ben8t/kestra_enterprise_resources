resource "kestra_role" "example" {
  name        = "Flow Developer"
  description = "Role with read and update permissions for flows and executions"

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
  name        = "Data Engineers"
  description = "Data engineering team with access to flows and executions"
}

resource "kestra_group" "test" {
  name = "TEST"
}

resource "kestra_group" "newgroup" {
  name = "newGroup"  
}

resource "kestra_binding" "example" {
  type        = "GROUP"
  external_id = kestra_group.example.id
  role_id     = kestra_role.example.id
}

resource "kestra_user" "example" {
  email       = "john@doe.com"
  namespace   = "company.team"
  description = "Senior Data Engineer"
  first_name  = "John"
  last_name   = "Doe"
  groups      = [kestra_group.example.id]
}

resource "kestra_user" "sarah_johnson" {
  email       = "sarah.johnson@doe.com"
  namespace   = "company.team"
  description = "Data Engineer"
  first_name  = "Sarah"
  last_name   = "Johnson"
  groups      = [kestra_group.example.id]
}

resource "kestra_user" "michael_chen" {
  email       = "michael.chen@doe.com"
  namespace   = "company.team"
  description = "Data Engineer"
  first_name  = "Michael"
  last_name   = "Chen"
  groups      = [kestra_group.example.id]
}

resource "kestra_user" "emily_rodriguez" {
  email       = "emily.rodriguez@doe.com"
  namespace   = "company.team"
  description = "Lead Data Engineer"
  first_name  = "Emily"
  last_name   = "Rodriguez"
  groups      = [kestra_group.example.id]
}

resource "kestra_user" "david_patel" {
  email       = "david.patel@doe.com"
  namespace   = "company.team"
  description = "Data Engineer"
  first_name  = "David"
  last_name   = "Patel"
  groups      = [kestra_group.example.id]
}

# Infrastructure Team Resources
resource "kestra_role" "infrastructure_admin" {
  name        = "Infrastructure Admin"
  description = "Role with admin permissions for infrastructure team"

  permissions {
    type        = "FLOW"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "EXECUTION"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "NAMESPACE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "NAMESPACE_FILE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "SERVICE_ACCOUNT"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "SECRET"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "KV"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "TEMPLATE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "WORKER_GROUP"
    permissions = ["READ", "UPDATE"]
  }
}

resource "kestra_group" "infrastructure" {
  name        = "Infrastructure"
  description = "Infrastructure team with admin access to manage system resources"
}

resource "kestra_binding" "infrastructure" {
  type        = "GROUP"
  external_id = kestra_group.infrastructure.id
  role_id     = kestra_role.infrastructure_admin.id
}

resource "kestra_user" "alex_kim" {
  email       = "alex.kim@acme.com"
  namespace   = "acme"
  description = "Lead Infrastructure Engineer"
  first_name  = "Alex"
  last_name   = "Kim"
  groups      = [kestra_group.infrastructure.id]
}

resource "kestra_user" "maria_santos" {
  email       = "maria.santos@acme.com"
  namespace   = "acme"
  description = "DevOps Engineer"
  first_name  = "Maria"
  last_name   = "Santos"
  groups      = [kestra_group.infrastructure.id]
}

resource "kestra_user" "james_wilson" {
  email       = "james.wilson@acme.com"
  namespace   = "acme"
  description = "Infrastructure Architect"
  first_name  = "James"
  last_name   = "Wilson"
  groups      = [kestra_group.infrastructure.id]
}

resource "kestra_user" "priya_sharma" {
  email       = "priya.sharma@acme.com"
  namespace   = "acme"
  description = "Site Reliability Engineer"
  first_name  = "Priya"
  last_name   = "Sharma"
  groups      = [kestra_group.infrastructure.id]
}

resource "kestra_role" "qa_full_crud" {
  name        = "QA Full CRUD"
  description = "Role with full CRUD permissions for QA"

  permissions {
    type        = "FLOW"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "EXECUTION"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "TEMPLATE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "NAMESPACE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "KVSTORE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "DASHBOARD"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "SECRET"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "GROUP"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "ROLE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "BINDING"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "AUDITLOG"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "BLUEPRINT"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "IMPERSONATE"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "SETTING"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "APP"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "APPEXECUTION"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "TEST"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "ASSET"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "USER"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "TENANT_ACCESS"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "SERVICE_ACCOUNT"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "INVITATION"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }

  permissions {
    type        = "GROUP_MEMBERSHIP"
    permissions = ["READ", "UPDATE", "CREATE", "DELETE"]
  }
}


resource "kestra_user" "qa_user" {
  email       = "qa.user@acme.com"
  namespace   = "acme"
  description = "QA Engineer"
  first_name  = "QA"
  last_name   = "User"
  groups      = [kestra_group.infrastructure.id]
}

resource "kestra_binding" "qa_user_full_crud" {
  type        = "USER"
  external_id = kestra_user.qa_user.id
  role_id     = kestra_role.qa_full_crud.id
}

resource "kestra_user_password" "qa_user_password" {
  user_id  = kestra_user.qa_user.id
  password = var.qa_user_password
}
