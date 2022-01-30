## Architecting for High Availability & Resiliency

![Plan Backup Restore](./media/plan_backup_restore.png)

## High Availability Considerations
AKS Configuration:
* Enable Uptime SLA for production workloads
* Use Availability Zones (with Standard Load Balancer)
* Use multiple node pools & nodes spanning AZs
* Configure resource requests and limits
* Configure Taints & Tolerations, Pod Affinity
* Scheduling workloads with AZs
  - to ensure pod replicas are spread evenly across zones : Use Pod Topology Aware Scheduling 
  - to ensure the PVs are located in the same zone as the pods:
     - Use Volume Binding Mode: WaitForFirstConsumer
     - Use StatefulSets
     - Use Zone-Redundant (ZRS) Disks (preview)
   - to optimally route traffic within the same zone to avoid unnecessary latency: 
      - Use Service Topology (deprecated in Kubernetes 1.21, +, feature state alpha)
      - Use Topology Aware Hints (from Kubernetes 1.21+, feature state alpha)


for Storage Class Configuration
* Use CSI Driver as it is the standard provider for exposing storage to applications running on Kubernetes
* Use Azure Disk with ZRS (currently in Preview) --> available via Azure Disk CSI Driver
* Use Azure File with ZRS

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
