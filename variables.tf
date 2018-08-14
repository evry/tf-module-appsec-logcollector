variable "name_prefix" {
  description = "This variable is used to name resources and is fetched from environment variable"
  type        = "string"
}

variable "vm_username" {
  description = "This variable is used to specify VM username and is fetched from environment variable"
  type        = "string"
}

variable "vm_password" {
  description = "This variable is used to specify VM password and is fetched from environment variable"
  type        = "string"
}

variable "existing_subnet_id" {
  description = "Id of the existing subnet to connect the NIC to"
  type        = "string"
}

variable "create_new_rg" {
  description = "Whether or not to create a new resource group"
  default     = false
}

variable "new_rg_name" {
  description = "If set this will be the name of the new resource group"
  default     = ""
}

variable "existing_rg" {
  description = "Name of the existing resource group to put the module resources in"
  default     = ""
}

variable "location" {
  description = "Default location for the azure resource"
  default     = "West Europe"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "The name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "Version of the image to apply"
  default     = "latest"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine"
  type        = "string"
  default     = "Standard_A2_V2"
}

variable "custom_data" {
  description = "Specifies custom data to supply to the machine (cloud-init script)"
  type        = "string"
  default     = ""
}