resource "azurerm_virtual_machine_extension" "vm_oms" {
  name  = "OMSExtension"
  count = var.enable_OMS_extension ? 1 : 0
  depends_on = [azurerm_virtual_machine.vm_virtualmachine]
  virtual_machine_id         = azurerm_virtual_machine.vm_virtualmachine.id
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