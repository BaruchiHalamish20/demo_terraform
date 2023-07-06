resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

# resource "azurerm_virtual_network" "example" {
#   name                = var.virtual_network_name
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name
#   address_space       = var.virtual_network_address_space
# }

# resource "azurerm_subnet" "example" {
#   name                 = var.subnet_name
#   resource_group_name  = azurerm_resource_group.example.name
#   virtual_network_name = azurerm_virtual_network.example.name
#   address_prefixes     = var.subnet_address_prefixes
# }

# resource "azurerm_network_interface" "example" {
#   name                = var.network_interface_name
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   ip_configuration {
#     name                          = var.ip_configuration_name
#     subnet_id                     = azurerm_subnet.example.id
#     private_ip_address_allocation = var.private_ip_allocation
#   }
# }

# resource "azurerm_virtual_machine" "example" {
#   name                = var.virtual_machine_name
#   location            = azurerm_resource_group.example.location
#   resource_group_name = azurerm_resource_group.example.name

#   network_interface_ids = [azurerm_network_interface.example.id]

#   vm_size = var.virtual_machine_size

#   storage_image_reference {
#     publisher = var.image_publisher
#     offer     = var.image_offer
#     sku       = var.image_sku
#     version   = var.image_version
#   }

#   storage_os_disk {
#     name              = var.os_disk_name
#     caching           = var.os_disk_caching
#     create_option = abspath("/")
#    # storage_account_type = var.os_disk_storage_account_type
#   }

#   os_profile {
#     computer_name  = var.virtual_machine_name
#     admin_username = var.admin_username
#     admin_password = var.admin_password
#   }
# }
