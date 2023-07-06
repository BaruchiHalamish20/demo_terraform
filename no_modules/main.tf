# Provider configuration
provider "azurerm" {
  features {}
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "west Europe"
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

# Subnet for web host
resource "azurerm_subnet" "web_subnet" {
  name                 = "web-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Subnet for PostgreSQL DB
resource "azurerm_subnet" "db_subnet" {
  name                 = "db-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Network security group for web subnet
resource "azurerm_network_security_group" "web_nsg" {
  name                = "web-nsg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "89.138.167.148"
    destination_address_prefix = "*"
  }
}

# Associate the network security group with the web subnet
resource "azurerm_subnet_network_security_group_association" "web_nsg_association" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.web_nsg.id
}

# Associate the network security group with the db subnet
resource "azurerm_subnet_network_security_group_association" "db_nsg_association" {
  subnet_id                 = azurerm_subnet.db_subnet.id
  network_security_group_id = azurerm_network_security_group.db_nsg.id
}

# Network security group for db subnet
resource "azurerm_network_security_group" "db_nsg" {
  name                = "db-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
    
  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "89.138.167.148"
    destination_address_prefix = "*"
  }
}

# Public IP for web host
resource "azurerm_public_ip" "web_public_ip" {
  name                = "web-public-ip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

# Network interface for web host
resource "azurerm_network_interface" "web_nic" {
  name                = "web-nic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

  ip_configuration {
    name                          = "web-ip-config"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip.id
  }
}

# Virtual machine for web host
resource "azurerm_virtual_machine" "web_vm" {
  name                  = "web-vm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  vm_size               = "Standard_B1s"
  network_interface_ids = [azurerm_network_interface.web_nic.id]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "web-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "web-vm"
    admin_username = "azureuser"
    admin_password = "azureuser11!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

# Network interface for db host - NO public IP

# resource "azurerm_network_interface"  "db_nic" {
#   name                = "db-nic"
#   resource_group_name = azurerm_resource_group.example.name
#   location            = azurerm_resource_group.example.location

#   ip_configuration {
#     name                          = "db-ip-config"
#     subnet_id                     =  azurerm_subnet.db_subnet.id
#     private_ip_address_allocation = "Dynamic"
#   }
# }



# Public IP for web host
resource "azurerm_public_ip" "db_public_ip" {
  name                = "db-public-ip"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  allocation_method   = "Static"
}

# Network interface for db host
resource "azurerm_network_interface" "db_nic" {
  name                = "db-nic"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location

ip_configuration {
    name                          = "db-ip-config"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.db_public_ip.id
  }
}

# Virtual machine for PostgreSQL DB
resource "azurerm_virtual_machine" "db_vm" {
  name                  = "db-vm"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  vm_size               = "Standard_B1s"
  #network_interface_ids = [azurerm_network_interface.db_nic.id] # Empty list as DB should not have a public IP
  network_interface_ids = [azurerm_network_interface.db_nic.id] # Empty list as DB should not have a public IP


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "db-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "db-vm"
    admin_username = "azureuser"
    admin_password = "azureuser11!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  connection {
    type     = "ssh"
    host     = azurerm_public_ip.db_public_ip.ip_address
    username = "azureuser"
    password = "azureuser11!"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install postgresql -y"
    ]
  }
}

# Output the virtual network information
output "virtual_network_id" {
  value = azurerm_virtual_network.example.id
}

output "web_subnet_id" {
  value = azurerm_subnet.web_subnet.id
}

output "db_subnet_id" {
  value = azurerm_subnet.db_subnet.id
}

output "web_vm_public_ip" {
  value = azurerm_public_ip.web_public_ip.ip_address
}

output "db_vm_public_ip" {
  value = azurerm_public_ip.db_public_ip.ip_address
}