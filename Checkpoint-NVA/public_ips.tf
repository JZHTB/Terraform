resource "azurerm_public_ip" "elb_public_ip" {
  name                    = local.elbPublicIPName
  resource_group_name     = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                = azurerm_resource_group.Checkpoint_ResourceGroup.location
  allocation_method       = "Static"
  sku                     = "standard"
  domain_name_label       = lower("${local.elbPublicIPName}-${random_string.naming_random_suffix.result}")
  idle_timeout_in_minutes = 30
  tags = {
    timestamp = timestamp()

  }
}

resource "azurerm_public_ip" "vm_public_ip" {
  name                    = "${var.namePrefix}-${local.nameSuffix[count.index]}-Pip"
  resource_group_name     = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                = azurerm_resource_group.Checkpoint_ResourceGroup.location
  allocation_method       = "Static"
  sku                     = "standard"
  domain_name_label       = lower("${var.namePrefix}-${local.nameSuffix[count.index]}-${random_string.naming_random_suffix.result}")
  idle_timeout_in_minutes = 30
  count                   = var.instanceCount
  tags = {
    timestamp = timestamp()
  }
}

resource "azurerm_public_ip" "vm_public_ip_management" {
  name                    = "${var.namePrefix}-Management-Pip"
  resource_group_name     = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                = azurerm_resource_group.Checkpoint_ResourceGroup.location
  allocation_method       = "Static"
  sku                     = "standard"
  domain_name_label       = lower("${var.namePrefix}-Management-${random_string.naming_random_suffix.result}")
  idle_timeout_in_minutes = 30
  tags = {
    timestamp = timestamp()
  }
}

resource "azurerm_public_ip" "vm_public_ip_cluster" {
  name                    = local.haPublicIPName
  resource_group_name     = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                = azurerm_resource_group.Checkpoint_ResourceGroup.location
  allocation_method       = "Static"
  sku                     = "standard"
  domain_name_label       = lower("${var.namePrefix}-${random_string.naming_random_suffix.result}")
  idle_timeout_in_minutes = 30
  tags = {
    timestamp = timestamp()
  }

}