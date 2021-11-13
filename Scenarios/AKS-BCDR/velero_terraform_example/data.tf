data "azurerm_subscription" "current" {}



data "azurerm_client_config" "current" {}


data "azurerm_kubernetes_cluster" "aks" {
  depends_on = [azurerm_kubernetes_cluster.aks]
  name                = "example-aks1"
  resource_group_name = "testvelero"
}

