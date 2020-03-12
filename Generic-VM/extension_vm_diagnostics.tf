resource "azurerm_virtual_machine_extension" "vm_vmdiag" {
  name                 = "IaaSDiagnostics"
  count                = var.enable_vm_disk_encryption ? 1 : 0
  depends_on           = [azurerm_virtual_machine.vm_virtualmachine]
  virtual_machine_id   = azurerm_virtual_machine.vm_virtualmachine.id
  publisher            = "Microsoft.Azure.Diagnostics"
  type                 = "IaaSDiagnostics"
  type_handler_version = "1.5"

  settings = <<SETTINGS
  {
    "xmlCfg": "${base64encode(data.template_file.xml.rendered)}",
    "storageAccount": "${var.diagnotics_storage_account_name}"
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
    "storageAccountName": "${var.diagnotics_storage_account_name}",
    "storageAccountKey": "${var.diagnotics_storage_account_name}"
  }
SETTINGS

}