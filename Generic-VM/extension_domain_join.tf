resource "azurerm_virtual_machine_extension" "vm_domain_join" {
  count                = var.enable_domain_join ? 1 : 0
  depends_on = [azurerm_virtual_machine.vm_virtualmachine]
  name                 = "${var.vm_name}_domain_join"
  virtual_machine_id   = azurerm_virtual_machine.vm_virtualmachine.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"

  settings = <<SETTINGS
  {
    "Name": "${var.ad_domain_name}",
    "User": "${var.ad_domain_join_user}@${var.ad_domain_name}",
    "OUPath": "${var.ad_ou_path}",
    "Restart": "true",
    "Options" :  "3"
}
SETTINGS

  protected_settings = <<SETTINGS
      {
        "Password": "${var.ad_domain_join_pw}"
      }
    SETTINGS
}
