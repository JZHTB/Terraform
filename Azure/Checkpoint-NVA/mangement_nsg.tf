
resource "azurerm_network_security_group" "management_nsg" {
  name                = local.nsgName
  resource_group_name     = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                = azurerm_resource_group.Checkpoint_ResourceGroup.location

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefixes    = var.allowedManagementClients
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "GAiA-portal"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.allowedManagementClients
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "GAiA-SmartConsole-1"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "18190"
    source_address_prefixes    = var.allowedManagementClients
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "GAiA-SmartConsole-2"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "19009"
    source_address_prefixes    = var.allowedManagementClients
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Logs"
    priority                   = 140
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "257"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "ICA-pull"
    priority                   = 150
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "18210"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "CRL-fetch"
    priority                   = 160
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "18264"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Policy-fetch"
    priority                   = 170
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "18191"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = local.default_tags
}

