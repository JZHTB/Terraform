resource "azurerm_virtual_machine" "Checkpoint_virtual_machine_primary" {
  name                = "${var.namePrefix}-${local.nameSuffix[count.index]}"
  count               = var.instanceCount
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location            = azurerm_resource_group.Checkpoint_ResourceGroup.location
  network_interface_ids = [
    count.index == 0 ? azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_primary.id : azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_secondary.id,
    azurerm_network_interface.Checkpoint_virtual_machine_NIC_backend[count.index].id
  ]
  primary_network_interface_id = count.index == 0 ? azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_primary.id : azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_secondary.id
  vm_size = var.vmSize
  zones   = [(count.index + 1)]

  storage_image_reference {
    publisher = local.imageReference.publisher
    offer     = local.imageReference.offer
    sku       = local.imageReference.sku
    version   = local.imageReference.version
  }

  plan {
    publisher = local.imageReference.publisher
    name      = local.imageReference.sku
    product   = local.imageReference.offer
  }

  storage_os_disk {
    name              = "${var.namePrefix}-${local.nameSuffix[count.index]}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.diskType
    disk_size_gb      = local.diskSizeGB
  }

  os_profile {
    computer_name  = lower("${var.namePrefix}-${local.nameSuffix[count.index]}")
    admin_username = local.adminUsername
    admin_password = var.adminPassword
    custom_data    = base64encode(local.customData)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.Checkpoint_diagnostic_storage_account.primary_blob_endpoint
  }

  tags = local.default_tags

}

resource "azurerm_network_interface" "Checkpoint_virtual_machine_NIC_frontend_primary" {
  name                          = "${var.namePrefix}-${local.nameSuffix[0]}-${local.nicName[0]}"
  resource_group_name           = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                      = azurerm_resource_group.Checkpoint_ResourceGroup.location
  enable_ip_forwarding          = true
  enable_accelerated_networking = true

  ip_configuration {
    primary                                 = true
    name                                    = "member-ip"
    subnet_id                               = var.frontendSubnetID
    private_ip_address_allocation           = "Static"
    private_ip_address                      = var.frontendIPs[0]
    public_ip_address_id                    = azurerm_public_ip.vm_public_ip.0.id
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.checkpoint_lb_external_backend_pool.id]
  }
  ip_configuration {
    name                          = "cluster-vip"
    subnet_id                     = var.frontendSubnetID
    private_ip_address_allocation = "Static"
    private_ip_address            = var.clusterVIP
    public_ip_address_id          = azurerm_public_ip.vm_public_ip_cluster.id
  }

  tags = local.default_tags

}

resource "azurerm_network_interface" "Checkpoint_virtual_machine_NIC_frontend_secondary" {
  name                          = "${var.namePrefix}-${local.nameSuffix[1]}-${local.nicName[0]}"
  resource_group_name           = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                      = azurerm_resource_group.Checkpoint_ResourceGroup.location
  enable_ip_forwarding          = true
  enable_accelerated_networking = true


  ip_configuration {
    primary                                 = true
    name                                    = "member-ip"
    subnet_id                               = var.frontendSubnetID
    private_ip_address_allocation           = "Static"
    private_ip_address                      = var.frontendIPs[1]
    public_ip_address_id                    = azurerm_public_ip.vm_public_ip.1.id
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.checkpoint_lb_external_backend_pool.id]
  }

  tags = local.default_tags

}

resource "azurerm_network_interface" "Checkpoint_virtual_machine_NIC_backend" {
  name                          = "${var.namePrefix}-${local.nameSuffix[count.index]}-${local.nicName[1]}"
  resource_group_name           = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                      = azurerm_resource_group.Checkpoint_ResourceGroup.location
  enable_ip_forwarding          = true
  enable_accelerated_networking = true
  count                         = var.instanceCount

  ip_configuration {
    primary                                 = true
    name                                    = "member-ip"
    subnet_id                               = var.backendSubnetID
    private_ip_address_allocation           = "Static"
    private_ip_address                      = var.backendIPs[count.index]
    load_balancer_backend_address_pools_ids = [azurerm_lb_backend_address_pool.checkpoint_lb_internal_backend_pool.id]
  }

  tags = local.default_tags

}
//Above deprecated load_balancer_backend_address_pools_ids is to be replaced only. with below resources when provider 2.0 released
//For now both resources must exist to prevent continual create/delete loop

resource "azurerm_network_interface_backend_address_pool_association" "frontend_primary" {
  network_interface_id    = azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_primary.id
  ip_configuration_name   = "member-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.checkpoint_lb_external_backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "frontend_secondary" {
  network_interface_id    = azurerm_network_interface.Checkpoint_virtual_machine_NIC_frontend_secondary.id
  ip_configuration_name   = "member-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.checkpoint_lb_external_backend_pool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_secondary" {
  network_interface_id    = azurerm_network_interface.Checkpoint_virtual_machine_NIC_backend[count.index].id
  ip_configuration_name   = "member-ip"
  count                   = var.instanceCount
  backend_address_pool_id = azurerm_lb_backend_address_pool.checkpoint_lb_internal_backend_pool.id
}
