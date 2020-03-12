resource "azurerm_backup_protected_vm" "vm_recovery_config" {
  resource_group_name = var.rsv_resource_group_name
  recovery_vault_name = var.rsv_name
  source_vm_id        = azurerm_virtual_machine.vm_virtualmachine.id
  backup_policy_id    = var.backup_policy_id
  depends_on = [azurerm_virtual_machine.vm_virtualmachine]

  count = var.enable_vm_backup_to_recovery_services ? 1 : 0

  lifecycle {
    ignore_changes = [
      backup_policy_id,
      tags
    ]
  }
}
