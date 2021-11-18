
#Reference existing resources
data "azurerm_subscription" "current" {}


data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name                = "example-aks1"
  resource_group_name = "testvelero"
}

#Service Principal to be used by velero/restic: if you need restic (for fileshare backup), currently restic does not support Azure managed identity
data "azuread_service_principal" "velero_sp" {
  display_name = "backup-velero-sp"
}


#Create Resources
resource "azuread_service_principal_password" "velero_sp_password" {
  service_principal_id = data.azuread_service_principal.velero_sp.object_id
}

resource "azurerm_role_assignment" "sp_velero_aks_node_rg" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, data.azurerm_kubernetes_cluster.aks.node_resource_group)
  principal_id         = data.azuread_service_principal.velero_sp.object_id
  role_definition_name = "Contributor"
}


#Deploy Velero
module "velero" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  location       = var.location

  resource_group_name           = var.resource_group_name
  aks_nodes_resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group

  velero_sp_tenantID = data.azurerm_client_config.current.tenant_id 
  velero_sp_clientID = data.azuread_service_principal.velero_sp.application_id 
  velero_sp_clientSecret = azuread_service_principal_password.velero_sp_password.value 

  velero_namespace        = var.velero_namespace
  velero_chart_repository = var.velero_chart_repository
  velero_chart_version    = var.velero_chart_version
  velero_values           = var.velero_values
  velero_storage_settings = var.velero_storage_settings
}

#Assign bakup storage account access to velero SP
#resource "azurerm_role_assignment" "velero" {
#  depends_on = [azurerm_kubernetes_cluster.aks,module.velero]
#  scope                = module.velero.backup_storage_account_id
#  role_definition_name = "Contributor"
#  principal_id         = data.azuread_service_principal.velero_sp.object_id
#}

resource "azurerm_role_assignment" "snapshot" {
  depends_on = [azurerm_kubernetes_cluster.aks,module.velero]
  scope                = module.velero.backup_resource_group_id
  role_definition_name = "Contributor"
  principal_id         = data.azuread_service_principal.velero_sp.object_id
}

resource "azurerm_role_assignment" "msi_aks_cp_velero_rg" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, var.resource_group_name)
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Managed Identity Operator"
}

