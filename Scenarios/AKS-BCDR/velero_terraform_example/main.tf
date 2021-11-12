data "azurerm_kubernetes_cluster" "aks" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name                = "example-aks1"
  resource_group_name = "testvelero"
}

data "azurerm_user_assigned_identity" "aad_pod_identity" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name                = "aad-pod-identity"
  resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
}


module "velero" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  location       = var.location

  resource_group_name           = var.resource_group_name
  aks_nodes_resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group

  velero_namespace        = var.velero_namespace
  velero_chart_repository = var.velero_chart_repository
  velero_chart_version    = var.velero_chart_version
  velero_values           = var.velero_values
  velero_storage_settings = var.velero_storage_settings
}


resource "azurerm_role_assignment" "msi_aks_cp_velero_rg" {
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, var.resource_group_name)
  principal_id         = data.azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  role_definition_name = "Managed Identity Operator"
}
