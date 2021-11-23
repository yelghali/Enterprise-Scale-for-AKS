# AKS Business Continuity & Disaster Recovery


building on: https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-multi-region#next-steps

![Architectural diagram for the secure baseline scenario.](./media/AKS-private-cluster-scenario.jpg)

## High Availability Considerations
Cluster Infrastructure:
* Use Availability Zones
* Use multiple node pools & nodes spanning AZs
* Configure Taints & Tolerations , Pod Affinity
* Use Toplogy Aware scheduling (optimally route traffic within the same zone to avoid latency)
* TODO: example / best practice for Taints & Tolerations using AZs

for storage sources (Storage Class Configuration)
* Use Azure Disk with ZRS (currently in Preview) --> available via Azure Disk CSI Driver
* Use Azure File with ZRS


* TODO: example / best practice for Storage Class configuration 
** Retention : Delete Vs Retain 
** VolumeBindingMode: Immediate VS WaitForFirstCustomer 
** Allowed Zones (to restrict Per)


## Disaster Recovey Considerations

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

## Risk / RPO/RTO based scenarios

## How Application Backup & Restore Works

## Backup Options for AKS persistent volumes

## AKS Disaster & Recovery 3rd party solutions 

## Practical example with Velero open source solution:


## A future workload for this scenario will include the following 
* Terraform example of Recovery to Another cluster

