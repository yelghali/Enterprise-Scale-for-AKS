###############
# velero resources on Azure
###############

resource "azurerm_resource_group" "velero" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "velero" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.velero.name
  location                 = azurerm_resource_group.velero.location
  account_kind             = "BlobStorage"
  account_tier             = "Standard"
  account_replication_type = "GRS"
  access_tier              = "Hot"
  min_tls_version          = "TLS1_2"

  enable_https_traffic_only = true

  tags = var.tags
}

resource "azurerm_storage_container" "velero" {
  name                  = local.storage_container_name
  storage_account_name  = azurerm_storage_account.velero.name
  container_access_type = "private"
}
