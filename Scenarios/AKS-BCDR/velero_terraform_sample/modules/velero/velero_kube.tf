
data "azurerm_subscription" "current" {
}

#install CSI driver for Azure File
resource "kubernetes_namespace" "azurefile_csi_driver" {
  metadata {
    name = var.azurefile_csi_driver_namespace
    labels = {
      deployed-by = "Terraform"
    }
  }
}
resource "helm_release" "azurefile_csi_driver" {
  name       = "azurefile-csi-driver"
  repository = var.azurefile_csi_driver_chart_repository
  chart      = "azurefile-csi-driver"
  version    = var.azurefile_csi_driver_chart_version
  namespace  = kubernetes_namespace.azurefile_csi_driver.metadata[0].name

  dynamic "set" {
    for_each = local.azurefile_csi_driver_values
    iterator = setting
    content {
      name  = setting.key
      value = setting.value
    }
  }
}

#install CSI driver for Azure Disk
resource "kubernetes_namespace" "azuredisk_csi_driver" {
  metadata {
    name = var.azuredisk_csi_driver_namespace
    labels = {
      deployed-by = "Terraform"
    }
  }
}
resource "helm_release" "azuredisk_csi_driver" {
  name       = "azuredisk-csi-driver"
  repository = var.azuredisk_csi_driver_chart_repository
  chart      = "azuredisk-csi-driver"
  version    = var.azuredisk_csi_driver_chart_version
  namespace  = kubernetes_namespace.azuredisk_csi_driver.metadata[0].name

  dynamic "set" {
    for_each = local.azuredisk_csi_driver_values
    iterator = setting
    content {
      name  = setting.key
      value = setting.value
    }
  }
}


resource "kubernetes_namespace" "velero" {
  metadata {
    name = var.velero_namespace
    labels = {
      deployed-by = "Terraform"
    }
  }
}


resource "kubernetes_secret" "velero" {
  metadata {
    name      = "cloud-credentials"
    namespace = kubernetes_namespace.velero.metadata[0].name
  }
  data = {
    cloud = local.velero_credentials
  }
}


resource "helm_release" "velero" {
  depends_on = [
    kubernetes_secret.velero,
    kubernetes_namespace.velero,
    azurerm_storage_account.velero,
  azurerm_storage_container.velero]
  name       = "velero"
  chart      = "velero"
  repository = var.velero_chart_repository
  namespace  = kubernetes_namespace.velero.metadata[0].name
  version    = var.velero_chart_version

  dynamic "set" {
    for_each = local.velero_values
    iterator = setting
    content {
      name  = setting.key
      value = setting.value
    }
  }

}
