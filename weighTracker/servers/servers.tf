resource "azurerm_linux_virtual_machine" "web_servers" {
  count                         = var.web_server_count
  name                          = "web-server-${count.index}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  size                          = var.web_server_size
  admin_username                = "adminuser"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.web_nic[count.index].id
  ]

  os_disk {
    name              = "web-server-${count.index}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "db_servers" {
  count                         = var.db_server_count
  name                          = "db-server-${count.index}"
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  size                          = var.db_server_size
  admin_username                = "adminuser"
  disable_password_authentication = true
  network_interface_ids = [
    azurerm_network_interface.db_nic[count.index].id
  ]

  os_disk {
    name              = "db-server-${count.index}-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}

resource "azurerm_network_interface" "web_nic" {
  count               = var.web_server_count
  name                = "web-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "web-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.web_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_public_ip[count.index].id
  }
}

resource "azurerm_network_interface" "db_nic" {
  count               = var.db_server_count
  name                = "db-nic-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "db-ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.db_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "web_public_ip" {
  count               = var.web_server_count
  name                = "web-public-ip-${count.index}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
}
