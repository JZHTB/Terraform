resource "azurerm_virtual_machine" "Checkpoint_virtual_machine_management" {
  name                = "${var.namePrefix}-Management"
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location            = azurerm_resource_group.Checkpoint_ResourceGroup.location
  network_interface_ids = [
  azurerm_network_interface.Checkpoint_virtual_machine_NIC_management.id]

  primary_network_interface_id = azurerm_network_interface.Checkpoint_virtual_machine_NIC_management.id
  vm_size                      = var.vmSize
  zones                        = [1]

  storage_image_reference {
    publisher = local.imageReference.publisher
    offer     = local.imageReference.offer
    sku       = local.managementSku
    version   = local.imageReference.version
  }

  plan {
    publisher = local.imageReference.publisher
    name      = local.managementSku
    product   = local.imageReference.offer
  }

  storage_os_disk {
    name              = "${var.namePrefix}-Management-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = var.diskType
    disk_size_gb      = local.diskSizeGB
  }

  os_profile {
    computer_name  = lower("${var.namePrefix}-Management")
    admin_username = local.adminUsername
    admin_password = var.adminPassword
    custom_data    = base64encode(local.managementCustomData)
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }

  boot_diagnostics {
    enabled     = "true"
    storage_uri = azurerm_storage_account.Checkpoint_diagnostic_storage_account.primary_blob_endpoint
  }
}



resource "azurerm_network_interface" "Checkpoint_virtual_machine_NIC_management" {
  name                          = "${var.namePrefix}-Management-${local.nicName[0]}"
  resource_group_name           = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location                      = azurerm_resource_group.Checkpoint_ResourceGroup.location
  enable_ip_forwarding          = false
  enable_accelerated_networking = false

  ip_configuration {
    primary                       = true
    name                          = "ip-config"
    subnet_id                     = var.frontendSubnetID
    private_ip_address_allocation = "Static"
    private_ip_address            = var.managementIP
    public_ip_address_id          = azurerm_public_ip.vm_public_ip_management.id
  }
}