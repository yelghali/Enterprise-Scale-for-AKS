
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

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    service_cidr       = var.network_profile.service_cidr
    load_balancer_sku  = var.network_profile.load_balancer_sku
  }

  role_based_access_control {
    enabled = true
  }


  tags = {
    Environment = "Production"
  }
}