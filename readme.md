# Module for creating a log collector node for Microsoft Cloud App Security

This modules creates a VM with Ubuntu Server 16.04-LTS to be used as a log collector node for Microsoft Cloud App Security

### Resources created when using this module
* Resource group
* Network Interface
* Public IP
* Virtual Machine, Ubuntu 16.04-LTS, with Standard_A2_V2 size as default

#### Using this module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| existing_rg_for_vnet | Name of the existing resource group containing the Virtual Network resource | string | - | yes |
| existing_subnet_name | Name of the existing subnet to connect the NIC to | string | - | yes |
| existing_vnet_name | Name of the existing Virtual Network | string | - | yes |
| create_new_rg	| Whether or not to create a new resource group. Allowed values are true or false |	bool | false	| yes |
| new_rg_name	| If set this will be the name of the new resource group |	string	| `` |	no |
| existing_rg	| Name of the existing resource group to put the module resources in |	string	| `` |	no |
| vm_size | Specifies the size of the virtual machine | string | `Standard_A2_V2` | no |
| image_offer | The name of the offer (az vm image list) | string | `UbuntuServer` | no |
| image_publisher | Name of the publisher of the image (az vm image list) | string | `Canonical` | no |
| image_sku | Image SKU to apply (az vm image list) | string | `16.04-LTS` | no |
| image_version | Version of the image to apply | string | `latest` | no |
| location | Default location for the azure resource | string | `West Europe` | no |
| name_prefix | This variable is used to name resources and is fetched from environment variable | string | - | yes* |
| vm_password | This variable is used to specify VM password and is fetched from environment variable | string | - | yes* |
| vm_username | This variable is used to specify VM username and is fetched from environment variable | string | - | yes* |
| custom_data | Specifies custom data to supply to the machine (cloud-init script) | string | `` | no |

**NOTE!**

Regarding inputs with required "yes*":

The variables `name_prefix`, `vm_password` and `vm_username` are required by the module and must be set to refer to variables in `variables.tf`.

The value of these variables will be set by environment variables when provisioning.

## Outputs

| Name | Description |
|------|-------------|
| logcollector_public_ip | The public IP to the Log Collector node |

### Example usage of this module
```
module "appsec-logcollector" {
  source = "../../../modules/appsec-logcollector"

  existing_subnet_name = "${azurerm_subnet.dmz.name}"
  existing_vnet_name   = "${azurerm_virtual_network.vnet.name}"
  existing_rg_for_vnet = "${azurerm_resource_group.rg.name}"
  create_new_rg        = true
  new_rg_name          = "appsec-logcollector-rg"
  name_prefix          = "${var.name_prefix}"
  vm_username          = "${var.vm_username}"
  vm_password          = "${var.vm_password}"
}
```