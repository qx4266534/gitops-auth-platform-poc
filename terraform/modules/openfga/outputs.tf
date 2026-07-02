output "store_id" {
  description = "ID van de OpenFGA store"
  value       = openfga_store.tenant_store.id
}

output "authorization_model_id" {
  description = "ID van het authorization model"
  value       = openfga_authorization_model.model.id
}
