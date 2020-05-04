data "azurerm_client_config" "current" {}

locals {
  templateName       = "ha"
  templateVersion    = "20200127"
  haPublicIPName     = "${var.namePrefix}-Pip"
  elbPublicIPName    = "${var.namePrefix}-FrontendLB-Pip"
  nicName            = ["eth0", "eth1"]
  elbName            = "${var.namePrefix}-FrontendLB"
  ilbName            = "${var.namePrefix}-BackendLB"
  ilbBEAddressPool   = "${local.ilbName}-pool"
  elbBEAddressPool   = "${local.elbName}-pool"
  appProbeName       = "health_prob_port"
  bootstrapScript64  = base64encode(var.bootstrapScript)
  customRole         = "b24988ac-610-42a0-ab88-20f7382dd24c"
  identity           = jsonencode("{\"type\": \"SystemAssigned\"}")
  nameSuffix         = ["Primary", "Secondary"]
  osVersion          = "R8030"
  adminUsername      = "notused"
  isBlink            = "true"
  storageAccountName = "sacpbootdiag${random_string.naming_random_suffix.result}"
  storageAccountType = "LRS"
  diskSizeGB         = 100
  installationType   = "cluster"
  customData         = "#!/usr/bin/python /etc/cloud_config.py\n\ninstallationType=\"${local.installationType}\"\nallowUploadDownload=\"${var.allowDownloadFromUploadToCheckPoint}\"\nosVersion=\"${local.osVersion}\"\ntemplateName=\"${local.templateName}\"\nisBlink=\"${local.isBlink}\"\ntemplateVersion=\"${local.templateVersion}\"\nbootstrapScript64=\"${local.bootstrapScript64}\"\nlocation=\"${var.location}\"\nsicKey=\"${var.sicKey}\"\ntenantId=\"${data.azurerm_client_config.current.tenant_id}\"\nvirtualNetwork=\"${var.virtualNetworkName}\"\nclusterName=\"${var.namePrefix}\"\nexternalPrivateAddresses=\"${var.clusterVIP}\"\n"
  imageOffer         = "imageOffer${local.osVersion}"
  imagePublisher     = "checkpoint"
  imageReference = {
    "offer" : "check-point-cg-r8030"
    "publisher" : "checkpoint"
    "sku" : "sg-byol"
    "version" : "latest"
  }
  default_tags = {
    timestamp = timestamp()
  }

  //managment specific locals
  nsgName              = "NSG-management"
  managementCustomData = "#!/usr/bin/python /etc/cloud_config.py\n\ninstallationType=\"management\"\nallowUploadDownload=\"${var.allowDownloadFromUploadToCheckPoint}\"\nosVersion=\"${local.osVersion}\"\ntemplateName=\"management\"\nisBlink=\"false\"\ntemplateVersion=\"20200127\"\nbootstrapScript64=\"${local.bootstrapScript64}\"\nlocation=\"${var.location}\"\nsicKey=\"${var.sicKey}\"\nmanagementGUIClientNetwork=\"${var.managementGUIClientNetwork}\"\n"
  managementSku        = "mgmt-byol"

}