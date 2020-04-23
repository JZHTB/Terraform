resource "azurerm_resource_group" "Checkpoint_ResourceGroup" {
  name     = var.resourceGroupName
  location = var.location

  tags = {
    timestamp = timestamp()
  }
}