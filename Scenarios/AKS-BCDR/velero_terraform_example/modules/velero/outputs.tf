output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.velero.id
  description = "ID of the user assigned identity"
}

output "user_assigned_identity_name" {
  value       = azurerm_user_assigned_identity.velero.name
  description = "Name of the user assigned identity"
}

