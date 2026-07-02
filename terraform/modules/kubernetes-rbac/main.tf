# Kubernetes RBAC Module
# Beheert namespaces, Roles en RoleBindings voor een tenant

# Namespaces
resource "kubernetes_namespace" "tenant_namespaces" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name = each.value.name
    labels = {
      "tenant.platform.bank/name" = var.tenant_name
      "tenant.platform.bank/department" = var.department
    }
    annotations = {
      "tenant.platform.bank/contact" = var.contact_email
    }
  }
}

# Resource Quota per namespace
resource "kubernetes_resource_quota" "quota" {
  for_each = { for ns in var.namespaces : ns.name => ns if ns.resource_quota != null }

  metadata {
    name      = "${each.value.name}-quota"
    namespace = kubernetes_namespace.tenant_namespaces[each.key].metadata[0].name
  }

  spec {
    hard = {
      "requests.cpu"    = each.value.resource_quota.cpu
      "requests.memory" = each.value.resource_quota.memory
      "limits.cpu"      = each.value.resource_quota.cpu
      "limits.memory"   = each.value.resource_quota.memory
      "pods"            = each.value.resource_quota.pods
    }
  }
}

# Network Policy — default deny
resource "kubernetes_network_policy" "default_deny" {
  for_each = { for ns in var.namespaces : ns.name => ns }

  metadata {
    name      = "default-deny"
    namespace = kubernetes_namespace.tenant_namespaces[each.key].metadata[0].name
  }

  spec {
    pod_selector {}
    policy_types = ["Ingress", "Egress"]
  }
}

# RoleBinding — Admins (Owners)
resource "kubernetes_role_binding" "admins" {
  for_each = toset(var.namespaces[*].name)

  metadata {
    name      = "${var.tenant_name}-admins"
    namespace = kubernetes_namespace.tenant_namespaces[each.value].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "admin"
  }

  dynamic "subject" {
    for_each = toset(var.owners)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

# RoleBinding — Editors (Developers)
resource "kubernetes_role_binding" "editors" {
  for_each = toset(var.namespaces[*].name)

  metadata {
    name      = "${var.tenant_name}-editors"
    namespace = kubernetes_namespace.tenant_namespaces[each.value].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  dynamic "subject" {
    for_each = toset(var.developers)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}

# RoleBinding — Viewers (POs)
resource "kubernetes_role_binding" "viewers" {
  for_each = toset(var.namespaces[*].name)

  metadata {
    name      = "${var.tenant_name}-viewers"
    namespace = kubernetes_namespace.tenant_namespaces[each.value].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  dynamic "subject" {
    for_each = toset(var.pos)
    content {
      kind      = "User"
      name      = subject.value
      api_group = "rbac.authorization.k8s.io"
    }
  }
}
