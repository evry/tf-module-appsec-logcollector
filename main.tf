terraform {
  required_version = ">= 0.11"
}

locals {
  environment = "${terraform.workspace == "default" ? "test" : terraform.workspace}"
}

resource "azurerm_resource_group" "logcollector_rg" {
  name     = "${var.new_rg_name}"
  location = "${var.location}"
  count    = "${var.create_new_rg ? 1 : 0}"

  tags = {
    Environment = "${local.environment}"
    ManagedBy   = "TF"
  }
}

resource "azurerm_public_ip" "logcollector_pip" {
  name                         = "${var.name_prefix}-logcollector_pip-${local.environment}"
  resource_group_name          = "${var.create_new_rg ? var.new_rg_name : var.existing_rg}"
  public_ip_address_allocation = "dynamic"
  location                     = "${var.location}"
  domain_name_label            = "seecure-fwlog"

  tags = {
    Environment = "${local.environment}"
    ManagedBy   = "TF"
  }
}

resource "azurerm_network_interface" "logcollector_eth0" {
  name                = "${var.name_prefix}-logcollector_eth0-${local.environment}"
  resource_group_name = "${var.create_new_rg ? var.new_rg_name : var.existing_rg}"
  location            = "${var.location}"

  ip_configuration {
    name = "logcollector_eth0-ipconfig"

    subnet_id                     = "${var.existing_subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.logcollector_pip.id}"
  }

  tags = {
    Environment = "${local.environment}"
    ManagedBy   = "TF"
  }
}

resource "azurerm_virtual_machine" "logcollector" {
  name                  = "${var.name_prefix}-logcollector-${local.environment}"
  resource_group_name   = "${var.create_new_rg ? var.new_rg_name : var.existing_rg}"
  location              = "${var.location}"
  network_interface_ids = ["${azurerm_network_interface.logcollector_eth0.id}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name          = "${var.name_prefix}-logcollector-osdisk-${local.environment}"
    caching       = "ReadWrite"
    create_option = "FromImage"
    disk_size_gb  = "250"
  }

  os_profile {
    computer_name  = "${var.name_prefix}-logcollector-${local.environment}"
    admin_username = "${var.vm_username}"
    admin_password = "${var.vm_password}" 
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    Environment = "${local.environment}"
    ManagedBy   = "TF"
    role        = "mcas-logcollector"
    ssh_ip      = "${azurerm_network_interface.logcollector_eth0.private_ip_address}"
    ssh_user    = "${var.vm_username}"
  }

}