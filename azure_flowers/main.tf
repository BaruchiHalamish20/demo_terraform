# Resource group
resource "azurerm_resource_group" "terraform_flowers_rg" {
  #can't use interpolation
  name     = "${var.resource_group_name}${var.project_name}"
  location = "West Europe"

  tags = {
    Environment = "Dev"
    Team        = "DevOps"
  }
}

#for interpolation (if you dont want to change th evariables) use locals:
# locals {
#   group_name = "${var.resource_group_name}${var.project_name}"
# }
# resource "azurerm_resource_group" "terraform_flowers_rg" {
#   #can't use interpolation
#   name     = local.group_name
#   location = "West Europe"
# }


# Virtual network
resource "azurerm_virtual_network" "terraform_flowers_vnet" {
  name                = "terraform-flowers-westeu-vnet"
  resource_group_name = azurerm_resource_group.terraform_flowers_rg.name
  location            = azurerm_resource_group.terraform_flowers_rg.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet for web host
resource "azurerm_subnet" "web_subnet" {
  virtual_network_name = azurerm_virtual_network.terraform_flowers_vnet.name
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.terraform_flowers_rg.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet for PostgreSQL DB
resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.terraform_flowers_rg.name
  virtual_network_name = azurerm_virtual_network.terraform_flowers_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

# # Network security group for web subnet
# resource "azurerm_network_security_group" "web_nsg" {
#   name                = "web-nsg"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location

#   security_rule {
#     name                       = "AllowHTTP"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "8080"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "AllowSSH"
#     priority                   = 101
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "89.138.167.148"
#     destination_address_prefix = "*"
#   }
# }

# # Associate the network security group with the web subnet
# resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
#   subnet_id                 = azurerm_subnet.web_subnet.id
#   network_security_group_id = azurerm_network_security_group.web_nsg.id

# }

# # Network security group for db subnet
# resource "azurerm_network_security_group" "db_nsg" {
#   name                = "db-nsg"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location

#   security_rule {
#     name                       = "AllowSSH"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "89.138.167.148"
#     destination_address_prefix = "*"
#   }
# }

# # Associate the network security group with the db subnet
# resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
#   subnet_id                 = azurerm_subnet.db_subnet.id
#   network_security_group_id = azurerm_network_security_group.db_nsg.id
# }

# # Public IP for web host
# resource "azurerm_public_ip" "web_public_ip" {
#   name                = "web-public-ip"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location
#   allocation_method   = "Static"
# }

# # Network interface for web host
# resource "azurerm_network_interface" "web_nic" {
#   name                = "web-nic"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location
#   ip_configuration {
#     name                          = "web-ip-config"
#     subnet_id                     = azurerm_subnet.web_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.web_public_ip.id
#   }

#   # network_security_group_id = azurerm_network_interface.web_nic.id   
# }


# # Public IP for PostgreSQL DB
# resource "azurerm_public_ip" "db_public_ip" {
#   name                = "db-public-ip"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location
#   allocation_method   = "Static"
# }

# # Network interface for PostgreSQL DB
# resource "azurerm_network_interface" "db_nic" {
#   name                = "db-nic"
#   resource_group_name = azurerm_resource_group.terraform_flowers.name
#   location            = azurerm_resource_group.terraform_flowers.location
#   ip_configuration {
#     name                          = "db-ip-config"
#     subnet_id                     = azurerm_subnet.db_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     public_ip_address_id          = azurerm_public_ip.db_public_ip.id
#   }

#   # network_security_group_id = azurerm_network_interface.db_nic.id
# }

# # Virtual machine for web host
# resource "azurerm_virtual_machine" "web_vm" {
#   name                  = "web-vm"
#   resource_group_name   = azurerm_resource_group.terraform_flowers.name
#   location              = azurerm_resource_group.terraform_flowers.location
#   vm_size               = "Standard_B1s"
#   network_interface_ids = [azurerm_network_interface.web_nic.id]

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "web-os-disk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   os_profile {
#     computer_name  = "web-vm"
#     admin_username = "azureuser"
#     admin_password = "azureuser11!"
#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

# }

# # Virtual machine for PostgreSQL DB
# resource "azurerm_virtual_machine" "db_vm" {
#   name                  = "db-vm"
#   resource_group_name   = azurerm_resource_group.terraform_flowers.name
#   location              = azurerm_resource_group.terraform_flowers.location
#   vm_size               = "Standard_B1s"
#   network_interface_ids = [azurerm_network_interface.db_nic.id]

#   storage_image_reference {
#     publisher = "Canonical"
#     offer     = "UbuntuServer"
#     sku       = "18.04-LTS"
#     version   = "latest"
#   }

#   storage_os_disk {
#     name              = "db-os-disk"
#     caching           = "ReadWrite"
#     create_option     = "FromImage"
#     managed_disk_type = "Standard_LRS"
#   }

#   storage_data_disk {
#     name              = "db-data-disk"
#     managed_disk_type = "Standard_LRS"
#     create_option     = "Empty"
#     disk_size_gb      = 4
#     lun               = "1"
#   }

#   os_profile {
#     computer_name  = "db-vm"
#     admin_username = "azureuser"
#     admin_password = "azureuser11!"

#   }

#   os_profile_linux_config {
#     disable_password_authentication = false
#   }

#  connection {
#     type     = "ssh"
#     host     = azurerm_public_ip.db_public_ip.ip_address
#     user     = "azureuser"  # SSH username for the provisioner
#     password = "azureuser11!"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install postgresql -y",
#       "sudo mkfs -t ext4 /dev/sdc",
#       "sudo mkdir /mnt/data",
#       "sudo mount /dev/sdc /mnt/data",
#       "sudo chown -R postgres:postgres /mnt/data",
#       "sudo sed -i 's|/var/lib/postgresql/10/main|/mnt/data|g' /etc/postgresql/10/main/postgresql.conf",
#       "sudo systemctl restart postgresql"
#     ]
#   }
# }


# Output subnet name
output "web_subnet_name" {
  value       = azurerm_subnet.web_subnet.name
  description = "web subnet name"
}

output "db_subnet_name" {
  value       = azurerm_subnet.db_subnet.name
  description = "web subnet name"
}

# # Output IP address and data disk information
# output "web_vm_ip_address" {
#   value       = azurerm_public_ip.web_public_ip.ip_address
#   description = "Public IP address of the web VM"
# }

# output "db_vm_ip_address" {
#   value       = azurerm_public_ip.db_public_ip.ip_address
#   description = "Public IP address of the DB VM"
# }

# output "db_vm_data_disk" {
#   value       = azurerm_virtual_machine.db_vm.storage_data_disk.0.name
#   description = "Data disk name of the DB VM"
# }

# output "web_vm_data_disk" {
#   value       = null
#   description = "Web VM does not have a data disk"
# }
