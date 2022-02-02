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


