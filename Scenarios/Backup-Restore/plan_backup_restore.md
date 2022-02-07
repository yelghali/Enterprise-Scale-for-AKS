## Architecting for High Availability & Resiliency

![Plan Backup Restore](./media/plan_backup_restore.png)

## High Availability Considerations
* **AKS Cluster Configuration**:
	- Enable Uptime SLA for production workloads
	- Use Availability Zones (with Standard Load Balancer)
	- Use multiple node pools & nodes spanning AZs
	- Configure resource requests and limits
	- Configure Taints & Tolerations, Node & Pod Affinity



* **Applications**: 
Scheduling workloads with AZs, see the article: https://docs.microsoft.com/en-us/azure/aks/operator-best-practices-advanced-scheduler
  - to ensure pod replicas are spread evenly across zones : Use Pod Topology Aware Scheduling 
  - to ensure the PVs are located in the same zone as the pods:
     - Use Volume Binding Mode: WaitForFirstConsumer
     - Use StatefulSets
     - Use Zone-Redundant (ZRS) Disks (preview)
   - to optimally route traffic within the same zone to avoid unnecessary latency: 
      - Use Service Topology (deprecated in Kubernetes 1.21, +, feature state alpha)
      - Use Topology Aware Hints (from Kubernetes 1.21+, feature state alpha)


* **Data**: 
Storage Class Configuration (used to create dynamic peristent volumes)
	- Use CSI Driver as it is the standard provider for exposing storage to applications running on Kubernetes
	- Use Azure Disk with ZRS (currently in Preview) --> available via Azure Disk CSI Driver
	- Use Azure File with ZRS


## Disaster Recovey Considerations


* Prepare Cluster & POD Identities
* Plan network segmentation & DNS resolution
* Prepare storage location in DR Region to store backups
* for AKS configuration: 
  * Prepare Storage classes & snapshot classes (naming, sku, topology aware configuration, binding mode)

* Node Pool Configuration
  * Create Nodes & re-deploy Node Configuration
  * Use Node Configuration Snapshot (currently in Preview)


* Run a Drill Tests:
	* Create secondary AKS ecosystem (ACR, Keyvault, App Gateway, Firewall, NSG)
	* Create secondary AKS Cluster (with its dependencies installed: aad-podid, velero, csi-drivers) + RBAC for Azure services & velero identity (backup tool)

	To restore **Stateless** Application: 
	* Redeploy Application Configuration using Devops CICD

	To restore **statefull** Application, you need to backup and restore:
	* Cluster configuration (storage classes, volumesnapshotclasses, technical pods)
	*  Persistent Volumes (Azure Disk & Azure Fileshare)
	*  Application Configuration (bound to the restored persistent volumes)


