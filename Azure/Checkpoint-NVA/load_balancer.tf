//External Facing Load Balancer.
resource "azurerm_lb" "checkpoint_lb_external" {
  name                = local.elbName
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location            = azurerm_resource_group.Checkpoint_ResourceGroup.location
  sku                 = "standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontend"
    public_ip_address_id = azurerm_public_ip.elb_public_ip.id
  }
}
resource "azurerm_lb_backend_address_pool" "checkpoint_lb_external_backend_pool" {
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  loadbalancer_id     = azurerm_lb.checkpoint_lb_external.id
  name                = local.elbBEAddressPool
}
resource "azurerm_lb_probe" "checkpoint_lb_external_backend_probe" {
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  loadbalancer_id     = azurerm_lb.checkpoint_lb_external.id
  name                = local.appProbeName
  port                = 8117
  protocol            = "TCP"
}

//Internal Facing Load Balancer.
resource "azurerm_lb" "checkpoint_lb_internal" {
  name                = local.ilbName
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  location            = azurerm_resource_group.Checkpoint_ResourceGroup.location
  sku                 = "standard"

  frontend_ip_configuration {
    name               = "LoadBalancerBackend"
    private_ip_address = var.backendLBIP
    subnet_id          = var.backendSubnetID
  }
}
resource "azurerm_lb_backend_address_pool" "checkpoint_lb_internal_backend_pool" {
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  loadbalancer_id     = azurerm_lb.checkpoint_lb_internal.id
  name                = local.ilbBEAddressPool
}
resource "azurerm_lb_probe" "checkpoint_lb_internal_backend_probe" {
  resource_group_name = azurerm_resource_group.Checkpoint_ResourceGroup.name
  loadbalancer_id     = azurerm_lb.checkpoint_lb_internal.id
  name                = local.appProbeName
  port                = 8117
  protocol            = "TCP"
}