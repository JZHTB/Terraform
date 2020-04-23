resource "azurerm_mssql_elasticpool" "elastic_pool" {
  name                = "sqlep-${local.resource_identifier}"
  resource_group_name = var.resource_group
  location            = var.location
  server_name         = azurerm_sql_server.sql.name
  max_size_gb         = var.sql_ep_max_size_gb

  sku {
    name     = var.sql_ep_sku_name
    tier     = var.sql_ep_sku_tier
    family   = var.sql_ep_sku_family
    capacity = var.sql_ep_sku_capacity
  }

  per_database_settings {
    min_capacity = var.sql_ep_min_capacity
    max_capacity = var.sql_ep_max_capacity
  }
}