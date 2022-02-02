locals {
  aadpodidentity_default_values = {
    "azureIdentity.enabled"     = "true"
    "azureIdentity.type"        = "0" #Managed Identity
    "azureIdentity.resourceID"  = azurerm_user_assigned_identity.aad_pod_identity.id
    "azureIdentity.clientID"    = azurerm_user_assigned_identity.aad_pod_identity.client_id
    "nmi.micNamespace"          = var.aadpodidentity_namespace
    "rbac.allowAccessToSecrets" = "false"
  }

  aadpodidentity_values = merge(local.aadpodidentity_default_values, var.aadpodidentity_values)
}
