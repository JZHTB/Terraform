resource "azurerm_network_security_group" "domain_controller_nsg" {
  name                = var.nsg-name
  location            = var.location
  resource_group_name = var.resource-group-name

  tags = var.tags

  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "AD-InboundTCP"
    priority                     = 100
    protocol                     = "TCP"
    source_port_range            = "*"
    destination_port_ranges      = ["53", "88", "135-137", "139", "389", "445", "464", "636", "3268-3269"]
    source_address_prefixes      = [var.spoke-ip-range]
    destination_address_prefixes = [var.domain-controller-ip-range]
  }
  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "AD-InboundUDP"
    priority                     = 110
    protocol                     = "UDP"
    source_port_range            = "*"
    destination_port_ranges      = ["53", "88", "123", "135", "137-139", "389", "445", "464", "636"]
    source_address_prefixes      = [var.spoke-ip-range]
    destination_address_prefixes = [var.domain-controller-ip-range]
  }
  security_rule {
    access                       = "Allow"
    direction                    = "Inbound"
    name                         = "AD-RCP-Inbound"
    priority                     = 120
    protocol                     = "TCP"
    source_port_range            = "*"
    destination_port_ranges      = ["49152-65535"]
    source_address_prefixes      = [var.spoke-ip-range]
    destination_address_prefixes = [var.domain-controller-ip-range]
  }
  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "AD-OutboundTCP"
    priority                     = 100
    protocol                     = "TCP"
    source_port_range            = "*"
    destination_port_ranges      = ["53", "88", "135-137", "139", "389", "445", "464", "636", "3268-3269"]
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = [var.spoke-ip-range]
  }
  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "AD-OutboundUDP"
    priority                     = 110
    protocol                     = "UDP"
    source_port_range            = "*"
    destination_port_ranges      = ["53", "88", "123", "135", "137-139", "389", "445", "464", "636"]
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = [var.spoke-ip-range]
  }
  security_rule {
    access                       = "Allow"
    direction                    = "Outbound"
    name                         = "AD-RPC-Outbound"
    priority                     = 120
    protocol                     = "TCP"
    source_port_range            = "*"
    destination_port_ranges      = ["49152-65535"]
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = [var.spoke-ip-range]
}

  dynamic "security_rule" {
    for_each = !var.lockdown-vnet ? [] : [1]
    content {
      access                     = "Deny"
      direction                  = "Inbound"
      name                       = "vnet-deny"
      priority                   = 1000
      protocol                   = "*"
      source_port_range          = "*"
      destination_port_range     = "*"
      source_address_prefix      = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    }
  }

  dynamic "security_rule" {
    for_each = !var.enable-rdp ? [] : [1]
    content {
      access                       = "Allow"
      direction                    = "Inbound"
      name                         = "allow"
      priority                     = 200
      protocol                     = "TCP"
      source_port_range            = "*"
      destination_port_range       = "3389"
      source_address_prefixes      = [var.rdp-source-range]
      destination_address_prefixes = [var.spoke-ip-range]
    }
  }



}

