##Environment variable

variable location {
  description = "The region in which to create resources"
  type        = string
  default     = "uksouth"
}

variable resource_identifier {
  description = "The root module naming convention"
  type        = string
}

variable resource_group {
  description = "The name of the resource group that this Virtual Network should belong to"
  type        = string
}

variable tags {
  description = "Map of tags to pass to resources"
  default     = {}
  type        = map
}

##SQL Server

variable sql_version {
  description = "(Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)"
  default     = "12.0"
  type        = string
}

variable administrator_login {
  description = "(Required) The administrator login name for the new server. Changing this forces a new resource to be created"
  type        = string
}

variable administrator_login_password {
  description = "(Required) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy"
  type        = string
}

variable allowed_subnet_id {
  description = "(Required) The ID of the subnet that the SQL server will be connected to"
  type        = string
}

##MSSQL Elastic Pool

variable zone_redundant {
  description = "(Optional) Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku. Defaults to false"
  type        = bool
  default     = false
}

variable sql_ep_max_size_gb {  
  description = "(Optional) The max data size of the elastic pool in gigabytes"
  type        = string
}

variable sql_ep_sku_name {
  description = "(Required) Specifies the SKU Name for this Elasticpool. The name of the SKU, will be either vCore based tier + family pattern (e.g. GP_Gen4, BC_Gen5) or the DTU based BasicPool, StandardPool, or PremiumPool pattern"
  type        = string
  default     = "GP_Gen5"
}

variable sql_ep_sku_tier {
  description = "(Required) The tier of the particular SKU. Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, or Premium. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based."
  type        = string
  default     = "GeneralPurpose"
}

variable sql_ep_sku_family {
  description = "(Optional) The family of hardware Gen4 or Gen5"
  type        = string
  default     = "Gen5"
}

variable sql_ep_sku_capacity {
  description = "(Required) The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based"
  type        = string
  default     = 2
}

variable sql_ep_min_capacity {
  description = "(Required) The minimum capacity all databases are guaranteed"
  type        = string
}

variable sql_ep_max_capacity {
  description = "(Required) The maximum capacity any one database can consume"
  type        = string
}