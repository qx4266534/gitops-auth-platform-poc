output "namespace_names" {
  description = "Namen van de aangemaakte namespaces"
  value       = [for ns in kubernetes_namespace.tenant_namespaces : ns.metadata[0].name]
}
