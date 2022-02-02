variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource."
  default = {
    "made-by" = "terraform"
  }
}

variable "backups_rg_name" {
  description = "RG to store backups and volume snapshots"
  type        = string
}

variable "backups_stracc_name" {
  description = "storage account to store backup files and configuration"
  type        = string
  default     = "velero"
}

variable "backups_stracc_container_name" {
  description = "storage account to store backup files and configuration"
  type        = string
  default     = "velero"
}

variable "velero_sp_tenantID" {
  description = "Tenant ID for service pricinpal used by velero/restic"
  type        = string
  default = ""
}

variable "velero_sp_clientID" {
  description = "Client ID for service pricinpal used by velero/restic"
  type        = string
  default = ""
}

variable "velero_default_volumes_to_restic" {
  description = "Use restic (file copy) by default to backup all volumes"
  type        = string
  default = "false"
}


variable "velero_restore_mode_only" {
  description = "Access mode for velero : backup/restore or restore only"
  type        = string
  default = "false"
}

variable "velero_sp_clientSecret" {
  description = "Client Secret for service pricinpal used by velero/restic"
  type        = string
  default = ""
}

variable "aks_nodes_resource_group_name" {
  description = "Name of AKS nodes resource group"
  type        = string
}

variable "velero_chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "https://vmware-tanzu.github.io/helm-charts"
}

variable "velero_storage_settings" {
  description = <<EOVS
Settings for Storage account and blob container for Velero

map(object({
  name                     = string 
  resource_group_name      = string 
  location                 = string 
  account_tier             = string 
  account_replication_type = string 
  tags                     = map(any) 
  allowed_cidrs            = list(string) 
  allowed_subnet_ids       = list(string) 
  container_name           = string 
}))

EOVS
  type        = map(any)
  default     = {}
}

variable "velero_values" {
  description = <<EOVV
Settings for Velero helm chart

map(object({ 
  configuration.backupStorageLocation.bucket                = string 
  configuration.backupStorageLocation.config.resourceGroup  = string 
  configuration.backupStorageLocation.config.storageAccount = string 
  configuration.backupStorageLocation.name                  = string 
  configuration.provider                                    = string 
  configuration.volumeSnapshotLocation.config.resourceGroup = string 
  configuration.volumeSnapshotLocation.name                 = string 
  credential.exstingSecret                                  = string 
  credentials.useSecret                                     = string 
  deployRestic                                              = string 
  env.AZURE_CREDENTIALS_FILE                                = string 
  metrics.enabled                                           = string 
  rbac.create                                               = string 
  schedules.daily.schedule                                  = string 
  schedules.daily.template.includedNamespaces               = string 
  schedules.daily.template.snapshotVolumes                  = string 
  schedules.daily.template.ttl                              = string 
  serviceAccount.server.create                              = string 
  snapshotsEnabled                                          = string 
  initContainers[0].name                                    = string 
  initContainers[0].image                                   = string 
  initContainers[0].volumeMounts[0].mountPath               = string 
  initContainers[0].volumeMounts[0].name                    = string 
  image.repository                                          = string 
  image.tag                                                 = string 
  image.pullPolicy                                          = string
  podAnnotations.aadpodidbinding                            = string
  podLabels.aadpodidbinding                                 = string

}))
EOVV
  type        = map(string)
  default     = {}
}

variable "velero_azureidentity_name" {
  description = "The name of the User Assigned identity for velero for a given AKS cluster"
  type        = string
  #default     = "velero"
}

variable "velero_namespace" {
  description = "Kubernetes namespace in which to deploy Velero"
  type        = string
  default     = "velero"
}

variable "velero_chart_version" {
  description = "Velero helm chart version to use"
  type        = string
  default     = "2.12.13"
}

#CSI Driver for Azure File
variable "azurefile_csi_driver_namespace" {
  description = "Kubernetes namespace in which to deploy CSI Driver for Azure File"
  type        = string
  default     = "azurefile-csi-driver"
}

variable "azurefile_csi_driver_chart_version" {
  description = "helm chart version to use for CSI Driver for Azure File"
  type        = string
  default     = "1.8.0"
}

variable "azurefile_csi_driver_chart_repository" {
  description = "helm chart URL to use for CSI Driver for Azure File"
  type        = string
  default     = "https://raw.githubusercontent.com/kubernetes-sigs/azurefile-csi-driver/master/charts"
}

variable "azurefile_csi_driver_values" {
  description = <<EOVV
Settings for Azure File CSI Driver helm chart

map(object({ 

}))
EOVV
  type        = map(string)
  default     = {}
}

#CSI Driver for Azure Disk
variable "azuredisk_csi_driver_namespace" {
  description = "Kubernetes namespace in which to deploy CSI Driver for Azure Disk"
  type        = string
  default     = "azuredisk-csi-driver"
}

variable "azuredisk_csi_driver_chart_version" {
  description = "helm chart version to use for CSI Driver for Azure Disk"
  type        = string
  default     = "1.8.0"
}

variable "azuredisk_csi_driver_chart_repository" {
  description = "helm chart URL to use for CSI Driver for Azure Disk"
  type        = string
  default     = "https://raw.githubusercontent.com/kubernetes-sigs/azuredisk-csi-driver/master/charts"
}

variable "azuredisk_csi_driver_values" {
  description = <<EOVV
Settings for Azure Disk CSI Driver helm chart

map(object({ 

}))
EOVV
  type        = map(string)
  default     = {}
}


#Naming conventions
variable "name_prefix" {
  description = "Prefix used in naming"
  type        = string
  default     = ""
}

variable "backups_region" {
  description = "Azure region to use"
  type        = string
}

variable "location_short" {
  description = "Short name of Azure regions to use"
  type        = string
  default     = ""
}

variable "client_name" {
  description = "Client name/account used in naming"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Project environment"
  type        = string
  default     = ""
}

variable "stack" {
  description = "Project stack name"
  type        = string
  default     = ""
}
