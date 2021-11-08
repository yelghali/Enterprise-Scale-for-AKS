resource "azurerm_user_assigned_identity" "velero" {
  name                = local.service_name
  resource_group_name = azurerm_resource_group.velero.name
  location            = azurerm_resource_group.velero.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "snapshot" {
  scope                = azurerm_resource_group.velero.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero" {
  scope                = azurerm_storage_account.velero.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_identity_role_aks" {
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
  scope                = "/subscriptions/f1236d4f-78b0-4b14-b0f5-a6b9838c9973/resourceGroups/MC_aks-draas_aks-draas-source_francecentral"
  role_definition_name = "Contributor"
}
