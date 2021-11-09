
resource "azurerm_resource_group" "aks_testvelero" {
  name     = "testvelero"
  location = "FranceCentral"
  tags     = var.tags
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "example-aks1"
  location            = "WestEurope"
  resource_group_name = azurerm_resource_group.aks_testvelero.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Production"
  }
}
