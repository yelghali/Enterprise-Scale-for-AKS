output "user_assigned_identity_id" {
  value       = azurerm_user_assigned_identity.velero.id
  description = "ID of the user assigned identity"
}

output "user_assigned_identity_name" {
  value       = azurerm_user_assigned_identity.velero.name
  description = "Name of the user assigned identity"
}

output "backup_storage_account_id" {
  value       = data.azurerm_storage_account.velero.id
  description = "ID of the storage account used to store backups"
}

output "backup_resource_group_id" {
  value       = data.azurerm_resource_group.velero.id
  description = "ID of the Resource Group used to store backups"
}
