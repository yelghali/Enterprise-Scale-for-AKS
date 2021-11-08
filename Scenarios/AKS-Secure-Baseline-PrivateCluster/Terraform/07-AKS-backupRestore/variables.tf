#############
# VARIABLES #
#############


variable "velero_ns_name" {
    default = "backups-velero"

}

variable "resource_group_name" {
    default = "backups-velero"

}

variable "resource_group_location" {
    default = "FranceCentral"

}

variable "aks_azure_managed_rg" {
    default = "MC_aks-draas_aks-draas-source_francecentral"

}

variable "tags" {
  type = map(string)

  default = {
    project = "cs-aks"
  }
}
