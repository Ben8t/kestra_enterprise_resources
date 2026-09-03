# Kestra 2.0 RBAC: roles declare `resources { type, actions }` with fine-grained
# actions (VIEW, LIST, EXECUTE, KILL, ...) instead of the pre-2.0 READ/CREATE/
# UPDATE/DELETE.
#
# Users keep their `groups` list: the instance-level user endpoint the provider
# uses grants tenant access for each group's tenant as a side effect, which is
# what makes the tenant-scoped bindings and passwords below work on Kestra 2.0.
# (Provider 2.0.0-rc1 has no kestra_user_tenant_access resource yet; switch to
# it plus kestra_user_group_membership once a later provider release ships it.)

# --- Data Engineers ------------------------------------------------------------

resource "kestra_role" "example" {
  name        = "Flow Developer"
  description = "Role with read and update permissions for flows and executions"

  resources {
    type    = "FLOW"
    actions = ["VIEW", "LIST", "EXPORT", "UPDATE", "EXECUTE", "DISABLE", "ENABLE", "VALIDATE"]
  }

  resources {
    type    = "EXECUTION"
    actions = ["VIEW", "LIST", "ACCESS_LOGS", "ACCESS_OUTPUTS", "ACCESS_FILES", "EXPORT", "FOLLOW", "UPDATE", "RESTART", "KILL", "REPLAY", "PAUSE", "RESUME", "CHANGE_LABELS", "UNQUEUE", "FORCE_RUN"]
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

# --- Infrastructure Team -------------------------------------------------------

resource "kestra_role" "infrastructure_admin" {
  name        = "Infrastructure Admin"
  description = "Role with admin permissions for infrastructure team"

  resources {
    type    = "FLOW"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE", "DISABLE", "ENABLE", "VALIDATE", "EXPORT", "IMPORT", "PROMOTE"]
  }

  resources {
    type    = "EXECUTION"
    actions = ["VIEW", "LIST", "UPDATE", "DELETE", "RESTART", "KILL", "REPLAY", "PAUSE", "RESUME", "CHANGE_LABELS", "ACCESS_LOGS", "ACCESS_OUTPUTS", "ACCESS_FILES", "EXPORT", "UNQUEUE", "FORCE_RUN", "FOLLOW"]
  }

  resources {
    type    = "TRIGGER"
    actions = ["VIEW", "LIST", "UNLOCK", "RESTART", "DELETE", "DISABLE", "ENABLE", "EXPORT", "BACKFILL"]
  }

  # MANAGE_FILES covers what the former NAMESPACE_FILE type granted.
  resources {
    type    = "NAMESPACE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "MANAGE_FILES"]
  }

  resources {
    type    = "SERVICE_ACCOUNT"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  resources {
    type    = "SECRET"
    actions = ["VIEW", "LIST", "UPDATE", "DELETE"]
  }

  resources {
    type    = "KVSTORE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  # The infrastructure team owns governance policies.
  resources {
    type    = "POLICY"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE", "EXPORT", "IMPORT"]
  }

  # TEMPLATE no longer exists in Kestra 2.0. WORKER_GROUP is an instance-owner
  # (super-admin) resource and cannot be granted through a role.
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

# --- QA -----------------------------------------------------------------------

resource "kestra_role" "qa_full_crud" {
  name        = "QA Full CRUD"
  description = "Role with full permissions on every assignable resource for QA"

  resources {
    type    = "FLOW"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE", "DISABLE", "ENABLE", "VALIDATE", "EXPORT", "IMPORT", "PROMOTE"]
  }

  resources {
    type    = "EXECUTION"
    actions = ["VIEW", "LIST", "UPDATE", "DELETE", "RESTART", "KILL", "REPLAY", "PAUSE", "RESUME", "CHANGE_LABELS", "ACCESS_LOGS", "ACCESS_OUTPUTS", "ACCESS_FILES", "EXPORT", "UNQUEUE", "FORCE_RUN", "FOLLOW"]
  }

  resources {
    type    = "TRIGGER"
    actions = ["VIEW", "LIST", "UNLOCK", "RESTART", "DELETE", "DISABLE", "ENABLE", "EXPORT", "BACKFILL"]
  }

  resources {
    type    = "NAMESPACE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "MANAGE_FILES"]
  }

  resources {
    type    = "KVSTORE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  resources {
    type    = "DASHBOARD"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  resources {
    type    = "SECRET"
    actions = ["VIEW", "LIST", "UPDATE", "DELETE"]
  }

  resources {
    type    = "CREDENTIAL"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  # Former GROUP_MEMBERSHIP merged into GROUP (MANAGE_MEMBERS).
  resources {
    type    = "GROUP"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "MANAGE_MEMBERS"]
  }

  resources {
    type    = "ROLE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  resources {
    type    = "BINDING"
    actions = ["VIEW", "LIST", "CREATE", "DELETE"]
  }

  resources {
    type    = "AUDITLOG"
    actions = ["VIEW", "LIST", "EXPORT"]
  }

  resources {
    type    = "BLUEPRINT"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  # Former SETTING split into SYSTEM_SETTINGS and TENANT_SETTINGS.
  resources {
    type    = "SYSTEM_SETTINGS"
    actions = ["VIEW", "UPDATE"]
  }

  resources {
    type    = "TENANT_SETTINGS"
    actions = ["VIEW", "UPDATE"]
  }

  # Former APPEXECUTION merged into APP.
  resources {
    type    = "APP"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE", "ACCESS_FILES", "ACCESS_LOGS"]
  }

  # Former TEST renamed to TESTSUITE.
  resources {
    type    = "TESTSUITE"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE"]
  }

  resources {
    type    = "ASSET"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "LOCK", "UNLOCK"]
  }

  # Former TENANT_ACCESS merged into USER; former IMPERSONATE type became the
  # USER.IMPERSONATE action.
  resources {
    type    = "USER"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "MANAGE_GROUP_MEMBERSHIP", "IMPERSONATE"]
  }

  resources {
    type    = "SERVICE_ACCOUNT"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
  }

  resources {
    type    = "INVITATION"
    actions = ["VIEW", "LIST", "CREATE", "DELETE"]
  }

  resources {
    type    = "POLICY"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE", "EXECUTE", "EXPORT", "IMPORT"]
  }

  resources {
    type    = "COPILOT"
    actions = ["USE"]
  }

  resources {
    type    = "MCP_SERVER"
    actions = ["VIEW", "LIST", "CREATE", "UPDATE", "DELETE"]
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
