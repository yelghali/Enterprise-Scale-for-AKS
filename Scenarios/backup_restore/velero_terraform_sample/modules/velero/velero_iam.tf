data "azurerm_resource_group" "aks_nodes_rg" {
  name  = var.aks_nodes_resource_group_name
}

data "azurerm_resource_group" "velero" {
  name  = var.backups_rg_name
}


data "azurerm_storage_account" "velero" {
  name  = var.backups_stracc_name
  resource_group_name  = var.backups_rg_name
}

resource "azurerm_user_assigned_identity" "velero" {
  name                = var.velero_azureidentity_name
  resource_group_name = data.azurerm_resource_group.aks_nodes_rg.name
  location            = data.azurerm_resource_group.aks_nodes_rg.location
  tags                = var.tags
}

resource "azurerm_role_assignment" "velero_backups_rg" {
  scope                = data.azurerm_resource_group.velero.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_backups_stracc" {
  scope                = data.azurerm_storage_account.velero.id
  role_definition_name = "Contributor"
  #role_definition_name = "Storage Account Key Operator Service Role"
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
}

resource "azurerm_role_assignment" "velero_identity_role_aks" {
  principal_id         = azurerm_user_assigned_identity.velero.principal_id
  scope                = try(data.azurerm_resource_group.aks_nodes_rg.id, "")
  role_definition_name = "Contributor"
}


resource "helm_release" "velero_identity" {
  depends_on = [helm_release.velero]
  chart      = "${path.module}/aad-bindings"
  name       = "velero-aad-bindings"
  namespace  = kubernetes_namespace.velero.metadata[0].name

  set {
    name  = "IdentityName"
    value = azurerm_user_assigned_identity.velero.name
  }

  set {
    name  = "IdentityID"
    value = azurerm_user_assigned_identity.velero.id
  }

  set {
    name  = "IdentityClientID"
    value = azurerm_user_assigned_identity.velero.client_id
  }
}
