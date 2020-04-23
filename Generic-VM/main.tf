## Generation of new keyvault secret which will store the password generated above
resource "azurerm_key_vault_secret" "vm_pwd" {
  name         = "${var.vm_name}-${var.vm_local_username}"
  value        = random_string.vm_rndstr.result
  key_vault_id = var.keyvault_id
}

resource "azurerm_network_interface" "vm_netinterface" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  enable_accelerated_networking = var.enable_accelerated_networking

  ip_configuration {
    name                          = "${var.vm_name}_ipconfig"
    private_ip_address_allocation = var.enable_vm_private_ip_address ? "static" : "dynamic"
    private_ip_address            = var.enable_vm_private_ip_address ? var.vm_ip : ""
    subnet_id                     = var.subnet_id
  }

  tags = var.nic_tags

}


resource "azurerm_virtual_machine" "vm_virtualmachine" {
  name                = var.vm_name
  location            = var.location
  resource_group_name = var.resource_group_name
  vm_size             = var.vm_size

  zones = [var.availability_zone]

  network_interface_ids = [azurerm_network_interface.vm_netinterface.id]


  storage_os_disk {
    name              = "${var.vm_name}_os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.vm_disk_size
  }
  storage_image_reference {
    id = var.vm_os_image_id
  }

  dynamic "storage_data_disk" {
    for_each = var.data_disks
    content {
      name              = "${var.vm_name}_${storage_data_disk.key}"
      create_option     = storage_data_disk.value["create_option"]
      disk_size_gb      = storage_data_disk.value["disk_size_gb"]
      managed_disk_type = storage_data_disk.value["managed_disk_type"]
      lun               = storage_data_disk.value["lun"]
    }
  }
  
  dynamic "boot_diagnostics" {
    #Ugly method for turnary on for_each, supply an empty and single item list :(
    for_each = var.boot_diag_storage_account_uri == "null" ? [] : ["1"]
    content {
      enabled     = true
      storage_uri = var.boot_diag_storage_account_uri
    }
  }


  os_profile {
    computer_name  = var.vm_name
    admin_username = var.vm_local_username
    admin_password = random_string.vm_rndstr.result

    custom_data = "base64encode(data.template_file.first_logon_script.rendered)"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = var.timezone
  }

  tags = var.vm_tags

}








