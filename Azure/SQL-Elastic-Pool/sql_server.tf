resource "azurerm_sql_server" "sql" {
  name                         = "sql-${local.resource_identifier}"
  resource_group_name          = var.resource_group
  location                     = var.location
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  tags                         = var.tags
}