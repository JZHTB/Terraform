//VM Config _ Mandatory
variable "location" {
  description = "Azure Region the Virtual Machine is deployed into."
  type        = string
}
variable "resource_group_name" {
  description = "Name of resource group being used"
  type        = string
}
variable "vm_name" {
  description = "Name of the Virtual Machine"
  type        = string
}
variable "subnet_id" {
  description = "ID of the subnet the Virtual Machine is attached to"
  type        = string
}
variable "availability_zone"{
  description = "Set the Availability Zone. "
  type        = string
}
variable "keyvault_id" {
  description = "ID of the keyvault being used to store secrets generated"
  type        = string
}
variable "vm_os_image_id" {
  description = "Specifies the ID of the Custom Image which the Virtual Machine should be created from. Changing this forces a new resource to be created."
}
variable "nic_name" {}

variable "vm_local_username" {
  description = "local admin username for Virtual Machine"
  type        = string
  default     = "localadmin"
}
variable "vm_disk_size" {
  description = "Size in GB of OS disk"
  type        = string
  default     = "64"
}
variable "timezone" {
  description = "Timezone for VM"
  type        = string
  default     = "UTC"
}
variable "vm_size" {
  description = "Size of VM"
  type        = string
  default     = "Standard_B2s"
}
variable "vm_ip" {
  description = " the private ip for the DC"
  type        = string
  default     = ""
}
variable "data_disks" {
  description = "a map of additional disks to add to the machine, including desired disk letter and drive size"
  default = {}
}

//Keyvault _ Disk Encryption and Secret Generation
variable "keyvault_uri" {
  description = "uri of the keyvault being used to store secrets generated"
  type        = string
  default     = ""
}


//Log Analytics (OMS)
variable "oms_workspace_id" {
  description = "ID of OMS workspace being used"
  type        = string
  default     = ""
}
variable "oms_workspace_key" {
  description = "Key being used for access to OMS workspace"
  type        = string
  default     = ""
}


//Diagnostics
variable "diagnotics_storage_account_name" {
  description = "name of storage account being used for the diagnostic extension"
  type        = string
  default     = ""
}
variable "diagnostics_storage_account_key" {
  description = "Key being used for access to storage account for the diagnostic extension"
  type        = string
  default     = ""
}


//Recovery Services
variable "rsv_resource_group_name" {
  description = "Resource group the recovery services vault resides in"
  type        = string
  default     = ""
}
variable "rsv_name" {
  description = "Name of recovery services vault being used"
  type        = string
  default     = ""
}
variable "backup_policy_id" {
  description = "ID of backup policy being used"
  type        = string
  default     = ""
}


//Tags
variable "vm_tags" {
  description = "Tags set on the virtual machine"
  type        = map(string)
}
variable "nic_tags" {
  description = "Tags set on network interfact attached the VM"
  type        = map(string)
}


//Active Directory Joining
variable "ad_domain_name" {
  description = "The name of the Domain to join"
  type        = string
  default     = ""
}
variable "ad_domain_join_user" {
  description = "The name of the user_name used to  join"
  type        = string
  default     = ""
}
variable "ad_ou_path" {
  description = "The OU path to add the machine"
  type        = string
  default     = ""

}
variable "ad_domain_join_pw" {
  description = "The password used by the ad_domain_join_user to authenticate domain joining"
  type        = string
  default     = ""

}


//Feature Switches
variable "enable_domain_join" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_vm_disk_encryption" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_vm_backup_to_recovery_services" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_first_login_script" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_OMS_extension" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_diagnostics_extension" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_anti_malware_extension" {
  description = ""
  type        = bool
  default     = false
}
variable "enable_vm_private_ip_address" {
  description = "designate if private IP is allocated statically or dynamically. "
  type        = bool
  default     = false
}
variable "enable_accelerated_networking" {
  description = "Enable accelerated networking on the NIC. This will handle policy/NSG in hardware. Only benefits intra_vnet traffic, no latency gain for traffic over peering"
  type        = bool
  default     = false
}
variable "enable_deploy_custom_image" {
  description = "Enable deployment of a custom image from a gallery as opposed to a public marketplace image"
  type        = bool
  default     = true
}
