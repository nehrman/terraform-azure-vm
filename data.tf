data "azurerm_resource_group" "images_rg" {
  name = "${var.rg_images_name}"
}

data "azurerm_image" "custom_image" {
  name                = "${var.custom_image_name}"
  resource_group_name = "${data.azurerm_resource_group.images-rg.name}"
}

data "azurerm_resource_group" "network-rg" {
  name = "${var.rg_network_name}"
}

data "azurerm_virtual_network" "network_vnet" {
  name = "${var.network_name}"
  resource_group_name = "${data.azurerm_resource_group.network-rg.name}"
}

data "azurerm_subnet" "network_subnet" {
  name                 = "${var.network_subnet_name}"
  virtual_network_name = "${data.azurerm_virtual_network.network-vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.network-rg.name}"
}

data "azurerm_network_security_group" "network_sg" {
  name                = "${var.sg_name}"
  resource_group_name = "${data.azurerm_resource_group.network-rg.name}"
}

data "azurerm_resource_group" "keyvault_rg" {
  name = "${var.rg_keyvault_name}"
}

data "azurerm_key_vault" "keyvault" {
  name                = "${var.sg_name}"
  resource_group_name = "${data.azurerm_resource_group.keyvault-rg.name}"
}











backup services already existing
backup service policy already existing

