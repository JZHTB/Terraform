//required variables
variable "nsg-name" {
  type = string
}
variable "resource-group-name" {
  type = string
}
variable "location" {
  type = string
}
variable "spoke-ip-range" {
  type = string
}
variable "domain-controller-ip-range" {
  type = string
}


//override variables
variable "enable-rdp" {
  type = bool
  default = "false"
}
variable "lockdown-vnet" {
  type = bool
  default = "false"
}
variable "rdp-source-range" {
  type = string
  default = ""
}
variable "tags" {
  type = map(string)
  default = {
    terraform = "True"
  }
}
