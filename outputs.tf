output "resource_group_id" {
  description = "id of resource group"
  value       = "${azurerm_resource_group.rg.id}"
}

output "resource_group_name" {
  description = "name of resource group"
  value       = "${azurerm_resource_group.rg.name}"
}

output "virtual_network_name" {
  description = "name of virtual network created in resource group"
  value       = "${azurerm_virtual_network.net.name}"
}

output "virtual_network_id" {
  description = "id of virtual network created in resource group"
  value       = "${azurerm_virtual_network.net.id}"
}

output "virtual_network_subnets_name" {
  description = "name of subnets created inside the new vNet"
  value       = "${azurerm_subnet.subnet.*.name}"
}

output "virtual_network_subnets_id" {
  description = "The ids of subnets created inside the new vNet"
  value       = "${azurerm_subnet.subnet.*.id}"
}
