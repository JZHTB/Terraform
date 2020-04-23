resource "azurerm_sql_virtual_network_rule" "vnet_rule" {
  name                                 = "vnetrule-${local.resource_identifier}"
  resource_group_name                  = var.resource_group
  server_name                          = azurerm_sql_server.sql.name
  subnet_id                            = var.allowed_subnet_id
  ignore_missing_vnet_service_endpoint = false
}
