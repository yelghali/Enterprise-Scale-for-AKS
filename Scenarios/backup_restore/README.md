## Overview

This repository contains these plugins to support running Velero on Microsoft Azure:

- An object store plugin for persisting and retrieving backups on Azure Blob Storage. Content of backup is log files, warning/error files, restore logs.

- A volume snapshotter plugin for creating snapshots from volumes (during a backup) and volumes from snapshots (during a restore) on Azure Managed Disks.
  - Since v1.4.0 the snapshotter plugin can handle the volumes provisioned by CSI driver `disk.csi.azure.com`

## Compatibility

Below is a listing of plugin versions and respective Velero versions that are compatible.

| Plugin Version  | Velero Version |
|-----------------|----------------|
| v1.4.x          | v1.8.x         |
| v1.3.x          | v1.7.x         |
| v1.2.x          | v1.6.x         |
| v1.1.x          | v1.5.x         |
| v1.1.x          | v1.4.x         |
| v1.0.x          | v1.3.x         |
| v1.0.x          | v1.2.0         |


## Filing issues

If you would like to file a GitHub issue for the plugin, please open the issue on the [core Velero repo][103]


## Kubernetes cluster prerequisites

Ensure that the VMs for your agent pool allow Managed Disks. If I/O performance is critical,
consider using Premium Managed Disks, which are SSD backed.

## See it in action : (it takes 5 minutes !)

The sample code provides a Terraform module to install & confiugre Velero, to backup an AKS Cluster and restore it to a secondary Region:


in the Primary Region (WestEurope in the sample)
- Create a source AKS cluster, configured with Availability zones
- Installs and configures Velero in source cluster **ak1** (Velero referencing backup location in secondary Region)

in the Secondary / Backup Region (NorthEurope)
- Create a Backup AKS cluster (to restore cluster **aks1**), configured with Availability zones
- Create a storage location (Azure Storage Account) to store backups 
- Installs and configures Velero in backup cluster **aks1-dr** (Velero referencing the same backup location in secondary Region)



* Connect to your Azure Cloud Shell on the Portal:
![Architectural diagram for the secure baseline scenario.](./media/AKS-private-cluster-scenario.jpg)

* Create the Service Principal, representing Velero, to perform backups & restores:

```bash
az ad sp create-for-rbac --name sp-velero-aks1 --role Reader
```

* Deploy the Terraform sample code:

```bash
cd velero_terraform_sample

terraform init
terraform plan
terraform apply
```

















## Risk / RPO/RTO based scenarios


## See it in action (Deploy the sample code in 5 minutes)!

* Create the Service Principal, representing Velero, to perform backups & restores: 

   **az ad sp create-for-rbac --name sp-velero-aks1 --role Reader**



## Plan your AKS backup & restore

Prepare Identities

Cluster Deployment

Node Pool Configuration
** Create Nodes & re-deploy Node Configuration
** Use Node Configuration Snapshot (currently in Preview)

For a **Stateless** Application: 
*Redeploy Application Configuration 

For a **statefull** Application, you need to backup & Restore:
** Persistent Volumes (Azure Disk & Azure Fileshare)
** Cluster configuration (technical pods)
** Application Configuration (linked with the restored persistent volumes)

## How Application Backup & Restore Works

## Backup Options for AKS persistent volumes

## AKS Disaster & Recovery 3rd party solutions 

## Practical example with Velero open source solution:


## A future workload for this scenario will include the following 
* Terraform example of Recovery to Another cluster

