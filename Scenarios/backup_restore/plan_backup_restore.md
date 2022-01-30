## Overview

This topic describes how to back up and restore AKS clusters using Velero and Azure Blob, as the storage location. 

Velero is an open-source community standard tool for backing up and restoring Kubernetes cluster objects and persistent volumes, and it supports a variety of storage providers to store its backups.

If a workload cluster crashes and fails to recover, you can use a Velero backup to restore its contents and internal API objects to a new cluster.

## Velero Features

- Backup & Restore of Kubernetes objects (Cluster configuration)
- Backup & Restore of persistent volumes


## How Velero works (High Level Architecture)

![Plan Backup Restore](./media/plan_backup_restore.png)
