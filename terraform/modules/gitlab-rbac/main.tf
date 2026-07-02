# GitLab RBAC Module
# Beheert GitLab groepen, projecten en membership voor een tenant

# Hoofdgroep voor de tenant
resource "gitlab_group" "tenant_group" {
  name        = var.tenant_name
  path        = var.tenant_name
  description = "Tenant group for ${var.display_name}"
  visibility_level = "private"
}

# Subgroepen per project
resource "gitlab_group" "project_subgroup" {
  for_each = { for p in var.projects : p.name => p }

  name             = each.value.name
  path             = each.value.name
  parent_id        = gitlab_group.tenant_group.id
  visibility_level = "private"
}

# Projecten binnen subgroepen
resource "gitlab_project" "projects" {
  for_each = merge([
    for p in var.projects : {
      for sub in p.sub_projects : "${p.name}/${sub}" => {
        name      = sub
        namespace = gitlab_group.project_subgroup[p.name].id
      }
    }
  ]...)

  name         = each.value.name
  namespace_id = each.value.namespace
  visibility_level = "private"
}

# Group memberships — Owners
resource "gitlab_group_membership" "owners" {
  for_each = toset(var.owners)

  group_id     = gitlab_group.tenant_group.id
  user_id      = each.value
  access_level = "owner"
}

# Group memberships — Developers
resource "gitlab_group_membership" "developers" {
  for_each = toset(var.developers)

  group_id     = gitlab_group.tenant_group.id
  user_id      = each.value
  access_level = "developer"
}

# Group memberships — POs (Planner)
resource "gitlab_group_membership" "pos" {
  for_each = toset(var.pos)

  group_id     = gitlab_group.tenant_group.id
  user_id      = each.value
  access_level = "planner"
}
