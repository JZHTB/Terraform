# Windows VM Module

This module will create a single instance of a Windows Virtual Machine in Azure, either with a market place image or a custom image from a shared gallery. 

There are a number of switches to enable varied extensions. 

The following configuration items are hard-coded to decrease the complexity of module use:

* Deployment is from a custom image that is preconfigured. The URI of this image is available to be supplied to the module. 
* A copy of the local administrator password will be saved in a Keyvault. A Keyvault will need to be available with the appropriate access policies.  
* The machine will be provisioned within an Availability_Zone and deployed in a region that supports AZs. 
* The virtual machine is to be provisioned with only a single NIC
* BYO Key is utilised when disk encryption is turned on via extension

Sample base call to module:
```
vm_name              = "VmName"  
resource_group_name  = "rg_sampleVM"
location             = "uksouth"
subnet_id            = "[ResourceID of Subnet]"
availability_zone    = "1"
keyvault_id          = "[ResourceID of Keyvault]" 
```


Sample call to module utilising all possible extensions and config items:
```
vm_name              = "VmName"  
resource_group_name  = "rg_sampleVM"
location             = "uksouth"
subnet_id            = "[ResourceID of Subnet]
availability_zone    = "1"
keyvault_id          = "[ResourceID of Keyvault]" 
vm_os_image_id       = [URI of prepared image]

vm_size = "Standard_DS3_v2"


enable_vm_disk_encryption     = true
enable_OMS_extension          = true
enable_anti_malware_extension = true
enable_accelerated_networking = true
enable_first_login_script     = true
enable_diagnostics_extension  = true

oms_workspace_id  = "9cc6cfb3_d67c_4776_a050_5039e39cee1e"
oms_workspace_key = "KVZtjnt/POUkyOkrvHg9J+mlN70tqQ16q5khIz5vc1NeL7aJNntRB2/ph2v893ReJUMtkY3IlHHrLuFjA2VLdw=="
keyvault_uri      = [URI of Keyvault]



data_disks = [
  {
    drive_letter      = "E"
    drive_label       = "Data"
    create_option     = "empty"
    disk_size_gb      = "100"
    managed_disk_type = "Standard_LRS"
    lun               = "10"
  },
  {
    drive_letter      = "G"
    drive_label       = "Mailboxes"
    create_option     = "empty"
    disk_size_gb      = "1024"
    managed_disk_type = "StandardSSD_LRS"
    lun               = "15"
}]

nic_tags = {
  time_stamp = "now"
}

vm_tags = {
  time_stamp = "now"
}
```

## Required Vars
| Variable | Type | Description|
|------|-----|-----|
| resource_group_name | string   | The name of the **existing** resource group to deploy these virtual networks in to|
| vm_name| string | The name of the virtual machine to be created|
| subnet_id | string | The resource ID of the **existing** subnet this VM is to be connected to |
| location | string |Azure location for the deployment|
| availability_zone  | string | The Availability to Provision this resource in, either 1 , 2, or 3 |
| vm_os_image_id | string | The URI to the custom image which the machine is to be created from.  |
| nic_name | string | The the name of the network interface |



## Optional Vars - VM Configuration
| Variable | Type | Description|
|-----|-----|-----|
| vm_local_username| string | Default: localadmin. The username of the local user admin account created on deploy. |
| vm_disk_size | string | Default: 64. The size, in GB of the OS disk |
| timezone | string | Default: UTC.  The timezone configured on the instance. |
| vm_size | string | Default: Standard_B2s.  The Azure size (SKU) of the VM. |
| data_disks | map(string) | Default: nil. To provision further data disks, over ride this value (see below) |



### data_disks 
The data_disk map will create _n_ of data disks in the following fashion. You must provide a drive_letter, drive_label, the create_option (i.e an empty disk or a pre_baked image from a library), managed_disk_type (specify the replication requirements) and lun

For each map provided bellow in a list a new disk is provisioned. 
```    {
       drive_letter      = "E"
       drive_label       = "Data"
       create_option     = "empty"
       disk_size_gb      = "100"
       managed_disk_type = "Standard_LRS"
       lun               = "10"```
       }
```
An additional extension, enabled with _enable_first_login_script_ will run a powershell script on the guest and format and label each of these instances. If you do not run the fist login script, the drive letter and label will be ignored. 

## Optional Vars - Disk Encryption

| Variable | Type | Description|
|-----|-----|-----|
| enable_vm_disk_encryption | bool | Default: false. Override to enable extension |
| keyvault_uri| string | Default: nil.  If Disk Encryption is enabled, you must provide a keyvault in order to store the encryption key |
 
 ## Optional Vars - Domain Joining
 
 | Variable | Type | Description|
 |-----|-----|-----|
 | enable_domain_join | bool | Default: false. Override to enable extension |
 | ad_domain_name| string | Default: nil.  The name of the Domain to join|
 | ad_domain_join_user| string | Default: nil.  The name of the user_name used to  join|
 | ad_ou_path| string | Default: nil.  The OU path to add the machine|
 | ad_domain_join_pw| string | Default: nil.  The password used by the ad_domain_join_user to authenticate domain joinin|

  ## Optional Vars - Rcovery Services
  
  | Variable | Type | Description|
  |------|-----|------|
  | enable_vm_backup_to_recovery_services | bool | Default: false. Override to enable extension |
  | rsv_resource_group_name| string | Default: nil.  Resource group the recovery services vault resides in|
  | rsv_name| string | Default: nil.  Name of recovery services vault being used|
  | backup_policy_id| string | Default: nil. ID of backup policy being used |
 
   ## Optional Vars - Diagnostics
   
   | Variable | Type | Description|
   |-----|-----|-----|
   | enable_diagnostics_extension | bool | Default: false. Override to enable extension |
   | diagnostics_storage_account_key| string | Default: nil.  name of storage account being used for the diagnostic extensio|
   | diagnotics_storage_account_name| string | Default: nil.  Key being used for access to storage account for the diagnostic extension|
  
    
   
  
  
 
## Optional Vars - Log Analytics (OMS)

| Variable | Type | Description|
|-----|-----|-----|
| enable_OMS_extension | bool | Default: false. Override to enable extension |
| oms_workspace_id | string | Default: nil. If extension enabled you must provide an OMS ID |
| oms_workspace_key| string | Default: nil.   If extension enabled you must provide an OMS Key |


## Optional Vars - additional Extension with no variable requirements. 
| Variable | Type | Description|
|-----|-----|-----|
| enable_accelerated_networking | bool | Default: false. Override to enable extension, SKU requirements for accelerated networking are higher |
| enable_diagnostics_extension | bool | Default: false. Override to enable extension |

## Optional Vars _ Private IP config 

| Variable | Type | Description|
|-----|-----|-----|
| enable_vm_private_ip_address | bool | Default: false. Override to enable provision of a static IP |
| vm_ip | string |  Default: nil.  Over ride this value with the full private IP of the machine if you wish to configure it. By default the VM will use a dynamic IP |

## Tags. 

the vm_tags and nic_tags variables can be over_written to apply tags to the resources. such as:

```
vm_tags = {
    tag1      = "tag1_value"
    timestamp = timestamp()
}
```
