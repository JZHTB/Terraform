# **Environment variables**

## **generic**

| Name                | Description                                                               |  Type  |  Default  | Required |
| ------------------- | ------------------------------------------------------------------------- | :----: | :-------: | :------: |
| location            | The region in which to create resources                                   | string | "uksouth" |    no    |
| resource_identifier | The root module naming convention                                         | string |    n/a    |  _yes_   |
| resource_group      | The name of the resource group that this Virtual Network should belong to | string |    n/a    |  _yes_   |
| tags                | Map of tags to pass to resources                                          |  map   |    {}     |    no    |

## **SQL Server**

| Name                         | Description                                                                                             |  Type  | Default | Required |
| ---------------------------- | ------------------------------------------------------------------------------------------------------- | :----: | :-----: | :------: |
| sql_version                  | The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)        | string | "12.0"  |    no    |
| administrator_login          | The administrator login name for the new server. Changing this forces a new resource to be created      | string |   n/a   |  _yes_   |
| administrator_login_password | The password associated with the administrator_login user. Needs to comply with Azure's Password Policy | string |   n/a   |  _yes_   |
| allowed_subnet_id            | The ID of the subnet that the SQL server will be connected to                                           | string |   n/a   |  _yes_   |

## **MSSQL Elastic Pool**

| Name                | Description                                                                                                                                                             |  Type  |     Default      | Required |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- | :----: | :--------------: | :------: |
| zone_redundant      | Whether or not this elastic pool is zone redundant. tier needs to be Premium for DTU based or BusinessCritical for vCore based sku. Defaults to false                   |  bool  |      false       |    no    |
| sql_ep_max_size_gb  | The max data size of the elastic pool in gigabytes                                                                                                                      | string |       n/a        |  _yes_   |
| sql_ep_sku_name     | The name of the SKU, will be either vCore based tier + family pattern (e.g. GP_Gen4, BC_Gen5) or the DTU based BasicPool, StandardPool, or PremiumPool pattern          | string |    "GP_Gen5"     |    no    |
| sql_ep_sku_tier     | Possible values are GeneralPurpose, BusinessCritical, Basic, Standard, or Premium                                                                                       | string | "GeneralPurpose" |    no    |
| sql_ep_sku_family   | The family of hardware Gen4 or Gen5                                                                                                                                     | string |      "Gen5"      |    no    |
| sql_ep_sku_capacity | The scale up/out capacity, representing server's compute units. For more information see the documentation for your Elasticpool configuration: vCore-based or DTU-based | string |        2         |    no    |
| sql_ep_min_capacity | The minimum capacity all databases are guaranteed                                                                                                                       | string |       n/a        |  _yes_   |
| sql_ep_max_capacity | The maximum capacity any one database can consume                                                                                                                       | string |       n/a        |  _yes_   |
