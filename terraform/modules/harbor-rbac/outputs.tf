output "project_ids" {
  description = "IDs van de Harbor projecten"
  value       = { for k, v in harbor_project.tenant_projects : k => v.id }
}

output "robot_account_name" {
  description = "Naam van de CI/CD robot account"
  value       = harbor_robot_account.cicd.name
}
