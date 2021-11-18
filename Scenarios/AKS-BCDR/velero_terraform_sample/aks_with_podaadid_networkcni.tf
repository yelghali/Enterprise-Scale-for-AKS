
resource "azurerm_resource_group" "aks_testvelero" {
  name     = "testvelero"
  location = "FranceCentral"
  tags     = var.tags
}


#resource "azurerm_user_assigned_identity" "aks_user_assigned_identity" {
#
#  name                = "mi-example-aks1-aks-cp"
#  location            = "WestEurope"
#  resource_group_name = azurerm_resource_group.aks_testvelero.name
#}


resource "azurerm_kubernetes_cluster" "aks" {
  name                = "example-aks1"
  location            = "WestEurope"
  resource_group_name = azurerm_resource_group.aks_testvelero.name
  dns_prefix          = "exampleaks1"

  default_node_pool {
    name       = "default"
    node_count = 3
    vm_size    = "Standard_D2_v2"
    availability_zones = ["1", "2", "3"]
  }


 role_based_access_control {
    enabled = true

  }

  identity {
    type                      = "SystemAssigned"
    #type                      = "UserAssigned"
    #user_assigned_identity_id = azurerm_user_assigned_identity.aks_user_assigned_identity.id
  }

  network_profile {
    network_plugin     = var.network_profile.network_plugin
    network_policy     = var.network_profile.network_policy
    dns_service_ip     = var.network_profile.dns_service_ip
    docker_bridge_cidr = var.network_profile.docker_bridge_cidr
    service_cidr       = var.network_profile.service_cidr
    load_balancer_sku  = var.network_profile.load_balancer_sku
  }



  tags = {
    Environment = "Production"
  }
}


# Allow user assigned identity to manage AKS items in MC_xxx RG
resource "azurerm_role_assignment" "aks_user_assigned" {
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
  scope                = format("/subscriptions/%s/resourceGroups/%s", data.azurerm_subscription.current.subscription_id, azurerm_kubernetes_cluster.aks.node_resource_group)
  role_definition_name = "Contributor"
}


module "infra" {
  source = "./modules/infra"

  providers = {
    kubernetes = kubernetes.aks-module
    helm       = helm.aks-module
  }

  aks_resource_group_name = azurerm_kubernetes_cluster.aks.node_resource_group
  location                = var.location

  aadpodidentity_chart_version    = var.aadpodidentity_chart_version
  aadpodidentity_chart_repository = var.aadpodidentity_chart_repository
  aadpodidentity_namespace        = var.aadpodidentity_namespace
  aadpodidentity_values           = var.aadpodidentity_values
}
