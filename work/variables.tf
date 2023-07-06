variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
  default     = "terraform-resource-group"
}

variable "location" {
  description = "The Azure region where the resources will be created."
  type        = string
  default     = "West Europe"
}

variable "virtual_network_name" {
  description = "The name of the virtual network."
  type        = string
  default     = "my-virtual-network"
}

variable "virtual_network_address_space" {
  description = "The address space for the virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the subnet."
  type        = string
  default     = "my-subnet"
}

variable "subnet_address_prefixes" {
  description = "The address prefixes for the subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "network_interface_name" {
  description = "The name of the network interface."
  type        = string
  default     = "my-network-interface"
}

variable "ip_configuration_name" {
  description = "The name of the IP configuration."
  type        = string
  default     = "my-ip-configuration"
}

variable "private_ip_allocation" {
  description = "The allocation method for the private IP address."
  type        = string
  default     = "Dynamic"
}

variable "virtual_machine_name" {
  description = "The name of the virtual machine."
  type        = string
  default     = "my-virtual-machine"
}

variable "virtual_machine_size" {
  description = "The size of the virtual machine."
  type        = string
  default     = "Standard_DS2_v2"
}

variable "image_publisher" {
  description = "The publisher of the virtual machine image."
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "The offer of the virtual machine image."
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "The SKU of the virtual machine image."
  type        = string
  default     = "18.04-LTS"
}

variable "image_version" {
  description = "The version of the virtual machine image."
  type        = string
  default     = "latest"
}

variable "os_disk_name" {
  description = "The name of the OS disk."
  type        = string
  default     = "my-os-disk"
}

variable "os_disk_caching" {
  description = "The caching option for the OS disk."
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "The storage account type for the OS disk."
  type        = string
  default     = "Standard_LRS"
}

variable "admin_username" {
  description = "The username for the virtual machine."
  type        = string
  default     = "adminuser"
}

variable "admin_password" {
  description = "The password for the virtual machine."
  type        = string
  default     = "adminpassword"
}
