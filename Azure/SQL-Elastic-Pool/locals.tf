locals {
  resource_identifier           = var.resource_identifier
  resource_identifier_no_hyphen = replace(local.resource_identifier, "-", "")
}
