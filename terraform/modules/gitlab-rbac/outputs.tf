output "group_id" {
  description = "ID van de GitLab tenant groep"
  value       = gitlab_group.tenant_group.id
}

output "group_path" {
  description = "Path van de GitLab tenant groep"
  value       = gitlab_group.tenant_group.path
}
