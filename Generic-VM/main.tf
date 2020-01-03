## Generate a random string, used as local admin password.
resource "random_string" "randomstring" {
  special = true
  upper   = true
  lower   = true
  number  = true
  length  = 16
}

## Generation of new keyvault secret which will store the password generated above
resource "azurerm_key_vault_secret" "vm_pwd" {
  name         = "${var.vm_name}-${var.vm_username}"
  value        = random_string.randomstring.result
  key_vault_id = var.keyvault_id
}

resource "azurerm_network_interface" "vm_netinterface" {
  name                = var.vm_name
  location            = var.region
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "${var.vm_name}-dcipconfig"
    private_ip_address_allocation = "static"
    private_ip_address            = var.vm_ip
    subnet_id                     = var.subnet_id
  }
}

##Create Availability Set - even if only a single VM. You cannot retrospectively add Availability Sets.
resource "azurerm_availability_set" "vm_aset" {
  name                        = var.vm_name
  location                    = var.region
  resource_group_name         = var.resource_group_name
  managed                     = "true"
  platform_fault_domain_count = 2
}

resource "azurerm_virtual_machine" "vm_virtualmachine" {
  name                  = var.vm_name
  location              = var.region
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.vm_netinterface.id]
  vm_size               = var.vm_size
  availability_set_id   = azurerm_availability_set.vm_aset.id
  depends_on            = [azurerm_network_interface.vm_netinterface, azurerm_availability_set.vm_aset]
  ##CIS Image
  plan {
    publisher = "center-for-internet-security-inc"
    name      = "cis-ws2019-l1"
    product   = "cis-windows-server-2019-v1-0-0-l1"
  }
  storage_image_reference {
    publisher = "center-for-internet-security-inc"
    offer     = "cis-windows-server-2019-v1-0-0-l1"
    sku       = "cis-ws2019-l1"
    version   = "latest"
  }

  storage_os_disk {
    name              = "${var.vm_name}-os"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = var.vm_disksize
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.vm_username
    admin_password = random_string.randomstring.result
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
    timezone                  = var.timezone
  }

}

resource "azurerm_virtual_machine_extension" "vm_antimalware" {
  name = "IaaSAntimalware"
  depends_on = [
  azurerm_virtual_machine.vm_virtualmachine]
  location             = var.region
  resource_group_name  = var.resource_group_name
  virtual_machine_name = var.vm_name
  publisher            = "Microsoft.Azure.Security"
  type                 = "IaaSAntimalware"
  type_handler_version = "1.5"

  settings = <<SETTINGS
    { "AntimalwareEnabled": true,
    "RealtimeProtectionEnabled": true,
    "ScheduledScanSettings": {
        "isEnabled": true,
        "day": "1",
        "time": "120",
        "scanType": "Full" },
        "Exclusions": {
            "Extensions": ".mdf;.ldf",
            "Paths": "c:\\windows;c:\\windows\\system32",
            "Processes": "taskmgr.exe;notepad.exe" }
            }
SETTINGS
}


resource "azurerm_virtual_machine_extension" "vm_oms" {
  name = "OMSExtension"
  depends_on = [
  azurerm_virtual_machine.vm_virtualmachine]
  location                   = var.region
  resource_group_name        = var.resource_group_name
  virtual_machine_name       = var.vm_name
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "MicrosoftMonitoringAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
      "workspaceId": "${var.oms_workspace_id}"
    }
    SETTINGS

  protected_settings = <<SETTINGS
{
"workspaceKey": "${var.oms_workspace_key}"
}
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "vm_vmdiag" {
  name     = "vmdiag"
  location = var.region
  depends_on = [
  azurerm_virtual_machine.vm_virtualmachine]
  resource_group_name  = var.resource_group_name
  virtual_machine_name = var.vm_name
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "IaaSDiagnostics"
  type_handler_version = "1.5"

  settings = <<SETTINGS
  {
    "xmlCfg": "${base64encode(data.template_file.xml-config.rendered)}",
    "storageAccount": "${var.diag_storage_account_name}"
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "storageAccountName": "${var.diag_storage_account_name}",
    "storageAccountKey": "${var.diag_storage_account_key}"
  }
SETTINGS

}


resource "azurerm_key_vault_key" "vm_encryptionkey" {
  name         = "${azurerm_virtual_machine.vm_virtualmachine.name}-disk-encryption"
  key_vault_id = var.keyvault_id
  depends_on = [
  azurerm_virtual_machine.vm_virtualmachine]
  key_type = "RSA"
  key_size = 2048
  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}
resource "azurerm_virtual_machine_extension" "vm_encryption" {
  name     = "DiskEncryption"
  location = var.region
  depends_on = [
  azurerm_key_vault_key.vm_encryptionkey]
  resource_group_name  = var.resource_group_name
  virtual_machine_name = var.vm_name
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"


  settings = <<SETTINGS
  {
    "EncryptionOperation": "EnableEncryption",
    "KeyVaultURL": "${var.keyvault_uri}",
    "KekVaultResourceId":"${var.keyvault_id}",
    "KeyVaultResourceId":"${var.keyvault_id}",
    "KeyEncryptionKeyURL":"${var.keyvault_uri}keys/${azurerm_key_vault_key.vm_encryptionkey.name}/${azurerm_key_vault_key.vm_encryptionkey.version}",
    "KeyEncryptionAlgorithm": "RSA-OAEP",
    "VolumeType": "All"
  }
SETTINGS
}

resource "azurerm_recovery_services_protected_vm" "vm_recovery_config" {
  resource_group_name = var.rsv_resource_group_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_virtual_machine.vm_virtualmachine.id
  backup_policy_id    = var.backup_policy_id
  lifecycle {
    ignore_changes = [
      backup_policy_id,
      tags
    ]
  }
}

##Data source with config for diagnostic settings
data "template_file" "xml-config" {
  template = file("${path.module}/diag-config.xml")
}
