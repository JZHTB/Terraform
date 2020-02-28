# Check Point CloudGuard R8030

This module will create a cluster of CloudGuard R8030's across availability-zones, ported from Checkpoints Marketplace image. At the time of writing the maximum zones within a region is 3, so at most this module can create 3 machines per region. 

This Module requires a pre-existing virtual network with a dedicated subnet for both front and backend resources. 

This Module will create the following in its own, newly created resource group:
* 2 Azure Load Balancers
* 4 Public IPs 
* 2 NICs and 1 VM per instance count (across Availability Zones) 
* 1 Management VM used for connection to SmartConsole. 
* a network security group that is attached to the front-end subnet




## Required Vars
| Variable | Type | Description|
|----------|------|------------|
| location | string   |Azure region in which this cluster is deployed|
| adminPassword| string|the password that is injected into the machine and set as root|
| resourceGroupName| string|the name of the resoruce group this is created on run time. Checkpoint enforce a **new** RG for the deployment of their resources.|
| sicKey| string|One time key for Secure Internal Communication|
| namePrefix| string|Name attached to the start of all resources. Used to adhere to naming conventions|
| frontendSubnetID| string|Resource ID of the subnet front-end resources should attach to|
| frontendIPs| list |List of the private IPs to set the front-end NICS|
| backendSubnetID| string|Resource ID of the subnet back-end resources should attach to|
| backendIPs| list |List of the private IPs to set the backed-end NICS|
| backendLBIP| list |The private ip attached to the backend Load Balancer|
| clusterVIP| string|VIP assigned to the active member of the cluster with its own dedicated Public IP|
| virtualNetworkName| string|Name of the **existing** virtual network to attach created resources to|
| allowedManagementClients| list| CIDR List of Ranges which are allowed access to the Management Console|
| managementIP| string | The single private IP attached to the management machine and front end subnet|
| managementGUIClientNetwork | string | Single CIDR range able to access the Checkpoint via GUI.|



## Optional Vars
| Variable | Type | Description|
|----------|------|------------|
| instanceCount| number |the number of virtual machines (and attached resoruces) that are created. Default 2|
| cloudGuardVersion| string|Default: BYOL. Override to change licence that is purchased on deployment|
| vmSize| string|Default: Standard_D3_v2. Size of deployed VMs|
| allowDownloadFromUploadToCheckPoint | bool|Default: True. Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point|
| diskType | string  |Default: Standard_LRS. The type of the OS disk.|
| bootstrapScript| string  |Default: "". over-ride to set custom bootstrap script.|


## Local Configuration

A number of naming variables and static configurations are configured within locals.tf. Most notably the customdata script that is injected into the machine on provisioning


## Sample Variable Declration

```
location = "uksouth"

resourceGroupName = "terraform-Checkpoint"

adminPassword = "[checkpoint admin password]"

sicKey = "[sicKey used for comms with CheckPoint]"

namePrefix = "Checkpoint"

frontendIPs = ["10.0.0.10","10.0.0.11"]

clusterVIP = "10.0.0.15"

backendIPs = ["10.0.1.10","10.0.1.11"]

backendLBIP = "10.0.1.15"

frontendSubnetID = "[resourceID - FrontEnd subnet]"

backendSubnetID = ""[resourceID - BackEnd subnet]""

virtualNetworkName = "[vNet Name]"```
