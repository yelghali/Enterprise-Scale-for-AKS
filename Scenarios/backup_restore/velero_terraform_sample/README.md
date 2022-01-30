
# Velero configuration for Microsoft Azure

## Overview

Velero is a plugin based tool. You can use the following plugins to run Velero on Microsoft Azure:

<a href="https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure" target="_blank">velero-plugin-for-microsoft-azure</a>, which provides:

- An object store plugin for persisting and retrieving backups on Azure Blob Storage. Content of backup is log files, warning/error files, restore logs.

- A volume snapshotter plugin for creating snapshots from volumes (during a backup) and volumes from snapshots (during a restore) on Azure Managed Disks.
  - It supports Azure Disk provisioned by Kubernetes driver `kubernetes.io/azure-disk`
  - Since v1.4.0 the snapshotter plugin can handle the volumes provisioned by CSI driver `disk.csi.azure.com`
  - IT DOES NOT support Azure File

 <a href="https://github.com/vmware-tanzu/velero-plugin-for-csi" target="_blank">velero-plugin-for-csi</a>
  - A pluging for snapshotting CSI backed PVCs using the CSI beta snapshot APIs for Kubernetes.
  - It supports Azure Disk `disk.csi.azure.com` and Azure File `file.csi.azure.com`

  <a href="https://velero.io/docs/v1.7/restic/" target="_blank">restic</a>
  - A plugin for backup using filesystem copy (and does not rely on snapshots)
  - It supports Azure Disk and Azure File, with both Kubernetes and CSI drivers.


 ## Compatibility

  Below is a listing of plugin versions and respective Velero versions that are compatible.

  | velero-plugin-for-microsoft-azure| Velero (with restic)  |   velero-plugin-for-csi | Kubernetes    |
  |----------------------------------|---------|-------------------------|---------------|           
  | v1.4.x                           | v1.8.x  |        N/A              |  1.16-latest  |
  | v1.3.x                           | v1.7.x  |       v0.2.0            |  1.12-latest  |
  | v1.2.x                           | v1.6.x  |       v0.1.2            |  1.12-1.21    |
  | v1.1.x                           | v1.5.x  |       v0.1.2            |  1.12-1.21    |
  | v1.1.x                           | v1.4.x  |       v0.1.1            |  1.12-1.21    |

  - https://github.com/vmware-tanzu/velero#velero-compatibility-matrix
  - https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#compatibility
  - https://github.com/vmware-tanzu/velero-plugin-for-csi#compatibility



## Using the module

```hcl
#Deploy Velero on primary cluster AKS1
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
  velero_restore_mode_only           = "false" #default value


  velero_sp_tenantID = data.azurerm_client_config.current.tenant_id 
  velero_sp_clientID = data.azuread_service_principal.velero_sp.application_id 
  velero_sp_clientSecret = azuread_service_principal_password.velero_sp_password.value 
}

```

 ## Understanding the sample code

 <a href="./01-aks1.tf" target="_blank">01-aks1.tf</a>:
  - Creates a Resource Group in Primary Region
  - Creates an AKS Cluster (used as primary)


 <a href="./02-aks-dr.tf" target="_blank">02-aks-dr.tf</a>:
  - Creates a Resource Group in Secondary Region
  - Creates an AKS Cluster (used as secondary, to restore backup)

 <a href="./03-backup-location.tf" target="_blank">03-backup-location.tf</a>:
  - Creates a Resource Group in Secondary Region, for hosting storage location (to store backups and velero configuration)
  - Creates a storage account 
  - Creates a storage container, used by velero (Optionnaly, you could create a secondary container, to backup to backup cluster)


 <a href="./main.tf" target="_blank">maint.tf</a>:
  - References the created ressources: primary and secondary RGs + AKS clusters + storage account (you should be able to reuse it for your existing resources)
  - Creates RBACs for Velero Service Principal. See this <a href="https://github.com/vmware-tanzu/velero-plugin-for-microsoft-azure#set-permissions-for-velero" target="_blank">article</a> for defining minium permissions.  
  - Installs Velero on the AKS Clusters using the provided module
















  How to Install Velero on AKS


  How to use velero to backup/restore Applications on AKS


  What does the example provide:
  * deploy sample AKS with POD Managed Identity + Network driver Azure CNI
  * deploy ressource group + storage account for storing backups
  * Configure AKS cluster with Velero server side resources and integrate with Storage location


  How to deploy from Azure Integrated console on your subscription: (folder velero_terraform_sample)
  * az ad sp create-for-rbac --name sp-velero-backup --role Reader
  * terraform init 
  * terraform plan
  * terraform apply



Deploy sample statefull applications: (folder application_samples)
* Statefull App (pod) with Azure managed disk
* Statefull App (pod) with Azure managed disk --> using restic for file level copy when using AKS with Availability zones
* Statefull App with Azure Fileshare --> requires tool restic (included in velero) which does not currently support POD Managed Identity with AAD


You need to install velero cli: https://velero.io/docs/v1.7/basic-install/#install-the-cli

sample commands for backup restore using velero cli --> You can not use "sudo" on Azure Integrated console, you can the download the cli binary but you'll to reference its path : e.g alias velero=/home/user/velero


Get AKS credentials: 
e.g using default values with provided example:az aks get-credentials --name example-aks1 --overwrite-existing --resource-group testvelero


velero backup-location get

velero backup get

velero backup create mybackup

velero backup describe mybackup

velero backup logs  mybackup

->delete ressources: kubectl delete pv,pvc,pod --all

velero restore create --from-backup mybackup

velero restore get


