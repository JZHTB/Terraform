//VM Sizing
variable "vm_disksize" {
  description = "Size of VM OS hard disk"
  type        = string
  default     = "64"
}

variable "vm_size" {
  description = "VM Size (SKU)"
  type        = string
  default     = "Standard_B2s"
}

//VM Generic Config
variable "vm_username" {
  description = "local admin username for dc"
  type        = string
  default     = "localadmin"
}

variable "timezone" {
  description = "Timezone for VMs"
  type        = string
}

variable "vm_name" {
  description = "Name of VM"
  type        = string
}

variable "resource_group_name" {
  description = "Name of resource group"
  type        = string
}

variable "region" {
  description = "Azure region"
  type        = string
}


//VM Networking
variable "vm_ip" {
  description = " the private ip for the VM"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet to attach NIC"
  type        = string
}

//Extension Config
variable "keyvault_id" {
  description = "ID of the keyvault being used to store secrets generated"
  type        = string
}

variable "keyvault_uri" {
  description = "uri of the keyvault, used to store bitlocker key"
  type        = string
}

variable "recovery_vault_name" {
  description = "Name of recovery vault machinet o be enrolled in"
  type        = string
}

variable "backup_policy_id" {
  description = "ID of backup policy attached to above recovery_vault_name"
  type        = string
}

variable "rsv_resource_group_name" {
  description = "Resource group the recovery services vault resides in"
  type        = string
}

variable "oms_workspace_id" {
  description = "ID of OMS workspace (log analytics), used by VM extension"
  type        = string
}

variable "oms_workspace_key" {
  description = "Key being used for access to OMS workspace"
  type        = string
}

variable "diag_storage_account_name" {
  description = "Name of storage account being used for the diagnostic extension"
  type        = string
}

variable "diag_storage_account_key" {
  description = "Key being used for access to storage account for the diagnostic extension"
  type        = string
}


