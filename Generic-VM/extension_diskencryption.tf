resource "azurerm_key_vault_key" "vm_encryptionkey" {
  name         = "${azurerm_virtual_machine.vm_virtualmachine.name}-disk-encryption-key"
  count = var.enable_vm_disk_encryption ? 1 : 0
  key_vault_id = var.keyvault_id
  depends_on = [azurerm_virtual_machine.vm_virtualmachine]
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
  count = var.enable_vm_disk_encryption ? 1 : 0
  depends_on = [azurerm_key_vault_key.vm_encryptionkey]
  virtual_machine_id   = azurerm_virtual_machine.vm_virtualmachine.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2"


  settings = <<SETTINGS
  {
    "EncryptionOperation": "EnableEncryption",
    "KeyVaultURL": "${var.keyvault_uri}",
    "KekVaultResourceId":"${var.keyvault_id}",
    "KeyVaultResourceId":"${var.keyvault_id}",
    "KeyEncryptionKeyURL":"${var.keyvault_uri}keys/${azurerm_key_vault_key.vm_encryptionkey[0].name}/${azurerm_key_vault_key.vm_encryptionkey[0].version}",
    "KeyEncryptionAlgorithm": "RSA_OAEP",
    "VolumeType": "All"
  }
SETTINGS
}
