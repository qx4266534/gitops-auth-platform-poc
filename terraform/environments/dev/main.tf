module "openfga" {
  source = "../../modules/openfga"

  tenant_name = var.tenant_name
  owners      = var.owners
  developers  = var.developers
  pos         = var.pos
}

module "gitlab_rbac" {
  source = "../../modules/gitlab-rbac"

  tenant_name  = var.tenant_name
  display_name = var.display_name
  projects     = var.projects
  owners       = var.owners
  developers   = var.developers
  pos          = var.pos
}

module "harbor_rbac" {
  source = "../../modules/harbor-rbac"

  tenant_name   = var.tenant_name
  project_names = var.harbor_projects
  owners        = var.owners
  developers    = var.developers
}

module "kubernetes_rbac" {
  source = "../../modules/kubernetes-rbac"

  tenant_name   = var.tenant_name
  department    = var.department
  contact_email = var.contact_email
  namespaces    = var.namespaces
  owners        = var.owners
  developers    = var.developers
  pos           = var.pos
}
