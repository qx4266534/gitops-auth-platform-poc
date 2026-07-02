# Harbor RBAC Module
# Beheert Harbor projecten en leden voor een tenant

resource "harbor_project" "tenant_projects" {
  for_each = toset(var.project_names)

  name                   = each.value
  public                 = false
  vulnerability_scanning = true
  retention_policy {
    always_retain_tags    = ["latest", "prod", "release-*"]
    days_since_last_pull  = 90
    days_since_last_push  = 90
  }
}

# Project members — Developers
resource "harbor_project_member_user" "developers" {
  for_each = toset(var.developers)

  project_id    = harbor_project.tenant_projects[var.project_names[0]].id
  user_name     = each.value
  role          = "developer"
}

# Project members — Maintainers
resource "harbor_project_member_user" "maintainers" {
  for_each = toset(var.owners)

  project_id    = harbor_project.tenant_projects[var.project_names[0]].id
  user_name     = each.value
  role          = "projectadmin"
}

# Robot account voor CI/CD
resource "harbor_robot_account" "cicd" {
  name        = "${var.tenant_name}-cicd"
  description = "CI/CD robot account for ${var.tenant_name}"
  level       = "project"
  permissions {
    access {
      action   = "push"
      resource = "repository"
    }
    access {
      action   = "pull"
      resource = "repository"
    }
    kind      = "project"
    namespace = var.project_names[0]
  }
}
