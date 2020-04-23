variable "location" {
  type        = string
  description = "Deployment location"
}
variable "instanceCount" {
  type        = number
  default     = 2
  description = "number of Checkpoint instances to deploy across Availability Zones."
}
variable "cloudGuardVersion" {
  type        = string
  default = "BYOL"
  description = "Check Point CloudGuard version"
}
variable "resourceGroupName" {
  type        = string
  description = "Name of RG to create. Checkpoint NVA requires its own RG"
}
variable "adminPassword" {
  type        = string
  description = "Administrator password"
}
variable "sicKey" {
  type        = string
  description = "One time key for Secure Internal Communication"
}
variable "namePrefix" {
  type        = string
  description = "Name attached to the start of all resources. "
}
variable "vmSize" {
  type        = string
  description = "Size of the VM"
  default     = "Standard_D3_v2"
}
variable "frontendSubnetID" {
  type        = string
  description = "The ID of the frontend subnet"
}
variable "frontendIPs" {
  type        = list(string)
  description = "The private ips attached to the front end NICs across the cluster as the member-ip"
}
variable "clusterVIP" {
  type        = string
  description = "VIP assigned to the active member of the cluster with its own dedicated Public IP"
}
variable "backendSubnetID" {
  type        = string
  default     = "SNET-CheckPointBackend"
  description = "The ID of the backend subnet"
}
variable "backendIPs" {
  type        = list(string)
  description = "The private ips attached to the backend NICs across the cluster as the member-ip"
}
variable "backendLBIP" {
  type        = string
  description = "The private ip attached to the backend LB"
}
variable allowDownloadFromUploadToCheckPoint {
  type        = bool
  default     = true
  description = "Automatically download Blade Contracts and other important data. Improve product experience by sending data to Check Point"
}
variable diskType {
  type        = string
  default     = "Standard_LRS"
  description = "The type of the OS disk."
}
variable "bootstrapScript" {
  type        = string
  default     = ""
  description = "Custom bootstrap script injected into machine at provision"
}
variable "virtualNetworkName" {
  type        = string
  description = "Name of the virtual network Checkpoint is attached to"
}


//management specific variables
variable "allowedManagementClients" {
  type        = list(string)
  description = "List of the CIDR ranges able to access the Checkpoint via Smart Console."
}
variable "managementIP" {
  type        = string
  description = "Private IP attached to the Management VM."
}
variable "managementGUIClientNetwork" {
  type        = string
  description = "Single CIDR range able to access the Checkpoint via GUI."
}
