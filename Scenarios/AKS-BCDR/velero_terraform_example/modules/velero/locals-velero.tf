locals {
  credentials = <<EOF
AZURE_SUBSCRIPTION_ID = ${try(data.azurerm_subscription.current.subscription_id, "")}
AZURE_RESOURCE_GROUP = ${var.aks_nodes_resource_group_name}
AZURE_CLOUD_NAME = AzurePublicCloud
EOF

  name_prefix = var.name_prefix != "" ? replace(var.name_prefix, "/[a-z0-9]/", "$0-") : ""

  storage_defaults_settings = {
    name                     = lower(substr(replace("velero${local.name_prefix}${var.stack}${var.client_name}${var.location_short}${var.environment}", "/[._\\- ]/", ""), 0, 24))
    resource_group_name      = var.resource_group_name
    location                 = var.location
    account_tier             = "Premium"
    account_replication_type = "LRS"
    tags                     = {}
    allowed_cidrs            = []
    allowed_subnet_ids       = []
    container_name           = "velero"
  }


  velero_default_values = {
    "configuration.backupStorageLocation.bucket"                = try(azurerm_storage_container.velero.name, "")
    "configuration.backupStorageLocation.config.resourceGroup"  = try(azurerm_storage_account.velero.resource_group_name, "")
    "configuration.backupStorageLocation.config.storageAccount" = try(azurerm_storage_account.velero.name, "")
    "configuration.backupStorageLocation.name"                  = "default"
    "configuration.provider"                                    = "azure"
    "configuration.volumeSnapshotLocation.config.resourceGroup" = try(var.aks_nodes_resource_group_name, "")
    "configuration.volumeSnapshotLocation.name"                 = "default"
    "credentials.existingSecret"                                = try(kubernetes_secret.velero.metadata[0].name, "")
    "credentials.useSecret"                                     = "true"
    "deployRestic"                                              = "true"
    "env.AZURE_CREDENTIALS_FILE"                                = "/credentials"
    "metrics.enabled"                                           = "true"
    "rbac.create"                                               = "true"
    "schedules.daily.schedule"                                  = "0 23 * * *"
    "schedules.daily.template.includedNamespaces"               = "{*}"
    "schedules.daily.template.snapshotVolumes"                  = "true"
    "schedules.daily.template.ttl"                              = "240h"
    "serviceAccount.server.create"                              = "true"
    "snapshotsEnabled"                                          = "true"
    "initContainers[0].name"                                    = "velero-plugin-for-azure"
    "initContainers[0].image"                                   = "velero/velero-plugin-for-microsoft-azure:v1.1.1"
    "initContainers[0].volumeMounts[0].mountPath"               = "/target"
    "initContainers[0].volumeMounts[0].name"                    = "plugins"
    "image.repository"                                          = "velero/velero"
    "image.tag"                                                 = "v1.4.0"
    "image.pullPolicy"                                          = "IfNotPresent"
    "podAnnotations.aadpodidbinding"                            = local.velero_identity_name
    "podLabels.aadpodidbinding"                                 = local.velero_identity_name
  }


  velero_credentials = local.credentials
  velero_storage     = merge(local.storage_defaults_settings, var.velero_storage_settings)
  velero_values      = local.velero_default_values

  velero_identity_name = "velero"
}
