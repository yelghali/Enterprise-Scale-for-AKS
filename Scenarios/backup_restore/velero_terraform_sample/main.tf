
#Reference existing resources
data "azurerm_subscription" "current" {}


data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_kubernetes_cluster" "aks" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name                = "example-aks1"
  resource_group_name = "testvelero"
}

data "azurerm_kubernetes_cluster" "aks_dr" {
  depends_on = [azurerm_kubernetes_cluster.aks_dr]
  name                = "aks-dr"
  resource_group_name = "aks-dr"
}


#Deploy Velero on source cluster AKS1
module "velero" {
  depends_on = [azurerm_kubernetes_cluster.aks]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  backups_region       = var.backups_region
  backups_rg_name           = var.backups_rg_name
  backups_stracc_name           = var.backups_stracc_name
  backups_stracc_container_name           = var.backups_stracc_container_name
  aks_nodes_resource_group_name = data.azurerm_kubernetes_cluster.aks.node_resource_group
  
  velero_azureidentity_name = "veleroaks1"
  velero_namespace        = var.velero_namespace
  velero_chart_repository = var.velero_chart_repository
  velero_chart_version    = var.velero_chart_version
  velero_values           = var.velero_values
}



#Deploy Velero on target restore cluster, referencing the same RG and storage for backups
module "veleroaksdr" {
  depends_on = [azurerm_kubernetes_cluster.aks_dr]

  source = "./modules/velero"

  providers = {
    kubernetes = kubernetes.aksdr-module
    helm       = helm.aksdr-module
  }

  backups_region       = var.backups_region
  backups_rg_name           = var.backups_rg_name
  backups_stracc_name           = var.backups_stracc_name
  backups_stracc_container_name           = "veleroforaksdr"  #todo: put in var
  aks_nodes_resource_group_name = data.azurerm_kubernetes_cluster.aks_dr.node_resource_group
  
  velero_azureidentity_name = "veleroaksdr"
  velero_namespace        = var.velero_namespace
  velero_chart_repository = var.velero_chart_repository
  velero_chart_version    = var.velero_chart_version
  velero_values           = var.velero_values
}
