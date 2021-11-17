
What does the example provide:
* deploy sample AKS with POD Managed Identity + Network driver Azure CNI
* deploy ressource group + storage account for storing backups
* Configure AKS cluster with Velero resources and integrate with Storage location


How to deploy:
*az ad sp create-for-rbac --name backup-velero-sp --role Reader
* terraform init 
* terraform plan
* terraform apply



Deploy sample statefull applications
* Statefull App (pod) with Azure managed disk
* Statefull App with Azure Fileshare --> requires tool restic (included in velero) which does not currently support POD Managed Identity with AAD

