resource "azurerm_storage_account" "Checkpoint_diagnostic_storage_account" {
  name                     = local.storageAccountName
  resource_group_name      = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                 = azurerm_resource_group.Checkpoint_ResourceGroup.location
  account_tier             = "Standard"
  account_replication_type = local.storageAccountType

  tags = {
    timestamp = timestamp()
  }
}