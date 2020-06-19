# Create Resource Group
resource "azurerm_resource_group" "vm" {
  name     = "${var.tf_az_env}-${var.tf_az_name}-rg"
  location = "${data.azurerm_resource_group.network-rg.location}"
  tags     = "${var.tf_az_tags}"
}

# Create Network Nic to use with VM
resource "azurerm_network_interface" "vm" {
  count                     = "${var.tf_az_nb_instance}"
  name                      = "${var.tf_az_env}-${var.tf_az_prefix}-nic-${count.index}"
  location                  = "${data.azurerm_resource_group.network-rg.location}"
  resource_group_name       = "${azurerm_resource_group.vm.name}"
  network_security_group_id = "${data.azurerm_network_security_group.network-sg.id}"

  ip_configuration {
    name                          = "ipconf${count.index}"
    subnet_id                     = "${data.azurerm_subnet.network-subnet.id}"
    private_ip_address_allocation = "dynamic"
  }

  tags = "${var.tf_az_tags}"
}

# Create Azure Virtual Machine
resource "azurerm_virtual_machine" "vm" {
  count                 = "${var.tf_az_nb_instance}"
  name                  = "${var.tf_az_env}-${var.tf_az_prefix}-vm-${count.index}"
  location              = "${data.azurerm_resource_group.network-rg.location}"
  resource_group_name   = "${azurerm_resource_group.vm.name}"
  network_interface_ids = ["${element(azurerm_network_interface.vm.*.id, count.index)}"]
  vm_size               = "${var.tf_az_instance_type}"

  delete_os_disk_on_termination = true

 storage_image_reference {
    id = "${data.azurerm_image.custom_image.id}"
}

  storage_os_disk {
    name              = "${var.tf_az_env}-${var.tf_az_prefix}-vm-${count.index}-osdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "${var.tf_az_prefix}${count.index}"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {
    disable_password_authentication = false
  }

  tags = "${var.tf_az_tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "azurerm_virtual_machine_extension" "vm" {
  count                      = "${lower(var.vm_os_type) == "windows" ? 1 : 0}"
  name                       = "${random_string.password.result}"
  location                   = "${data.azurerm_resource_group.network-rg.location}"
  resource_group_name        = "${azurerm_resource_group.vm.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.vm.*.name}"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = "${var.type_handler_version == "" ? "2.2" : var.type_handler_version}"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "${var.encrypt_operation}",
        "KeyVaultURL": "${data.azurerm_key_vault.keyvault.vault_uri}",
        "KeyVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionKeyURL": "${var.encryption_key_url}",
        "KekVaultResourceId": "${data.azurerm_key_vault.keyvault.id}",					
        "KeyEncryptionAlgorithm": "${var.encryption_algorithm}",
        "VolumeType": "${var.volume_type}"
    }
SETTINGS

  tags = "${var.tags}"
}

resource "azurerm_recovery_services_protected_vm" "vm" {
  count               = "${var.vm_backup == true ? 1 : 0}"
  resource_group_name = "${azurerm_resource_group.example.name}"
  recovery_vault_name = "${azurerm_recovery_services_vault.example.name}"
  source_vm_id        = "${azurerm_virtual_machine.vm.id}"
  backup_policy_id    = "${azurerm_recovery_services_protection_policy_vm.example.id}"
}

