#############
# VARIABLES #
#############

variable "location" {
    default = "WestEurope"

}

variable "velero_namespace" {
    default = "velero"

}

variable "backups_rg_name" {
    default = "backups-aks1"

}

variable "backups_region" {
    default = "NorthEurope"

}

variable "backups_stracc_name" {
    default = "backupsveleroaks1"

}

variable "backups_stracc_container_name" {
    default = "velero"

}

#variable "aks_azure_managed_rg" {
#    type = string
#}

variable "tags" {
  type = map(string)

  default = {
    project = "cs-aks"
  }
}

##########################
# Velero variables
##########################
variable "enable_velero" {
  description = "Enable velero on AKS cluster"
  type        = bool
  default     = true
}

variable "velero_storage_settings" {
  description = <<EOVS
Settings for Storage account and blob container for Velero
```
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
```
EOVS
  type        = map(any)
  default     = {}
}

variable "velero_values" {
  description = <<EOVV
Settings for Velero helm chart:
```
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
```
EOVV
  type        = map(string)
  default     = {}
}

variable "velero_chart_version" {
  description = "Velero helm chart version to use"
  type        = string
  default     = "2.12.13"
}

variable "velero_chart_repository" {
  description = "URL of the Helm chart repository"
  type        = string
  default     = "https://vmware-tanzu.github.io/helm-charts"
}

##########################
# AAD Pod Identity variables
##########################
variable "aadpodidentity_values" {
  description = <<EOD
Settings for AAD Pod identity helm Chart:
```
map(object({ 
  nmi.nodeSelector.agentpool  = string 
  mic.nodeSelector.agentpool  = string 
  azureIdentity.enabled       = bool 
  azureIdentity.type          = string 
  azureIdentity.resourceID    = string 
  azureIdentity.clientID      = string 
  nmi.micNamespace            = string 
}))
```
EOD
  type        = map(string)
  default     = {}
}

variable "velero_azureidentity_name" {
  description = "The name of the User Assigned identity for velero for a given AKS cluster"
  type        = string
  default     = "velero"
}

variable "aadpodidentity_namespace" {
  description = "Kubernetes namespace in which to deploy AAD Pod Identity"
  type        = string
  default     = "kube-system"
}

variable "aadpodidentity_chart_repository" {
  description = "AAD Pod Identity Helm chart repository URL"
  type        = string
  default     = "https://raw.githubusercontent.com/Azure/aad-pod-identity/master/charts"
}

variable "aadpodidentity_chart_version" {
  description = "AAD Pod Identity helm chart version to use"
  type        = string
  default     = "2.0.0"
}

variable "private_ingress" {
  description = "Private ingress boolean variable. When `true`, the default http listener will listen on private IP instead of the public IP."
  type        = bool
  default     = false
}

variable "appgw_private_ip" {
  description = "Private IP for Application Gateway. Used when variable `private_ingress` is set to `true`."
  type        = string
  default     = null
}


##########################
# AKS Cluster variables
##########################

variable "network_profile" {
  description = "Variables defining the AKS network profile config"
  type = object({
    network_plugin     = string
    network_policy     = string
    dns_service_ip     = string
    docker_bridge_cidr = string
    service_cidr       = string
    load_balancer_sku  = string
  })
  default = {
    network_plugin     = "azure"
    network_policy     = "azure"
    dns_service_ip     = "10.3.0.10"
    docker_bridge_cidr = "172.17.0.1/16"
    service_cidr       = "10.3.0.0/24"
    load_balancer_sku  = "Standard"
  }
}
