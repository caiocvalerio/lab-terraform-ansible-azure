resource "azurerm_linux_virtual_machine" "app_vm" {
  name                            = var.vm_name
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = data.azurerm_resource_group.rg.location
  size                            = "Standard_B1s"
  admin_username                  = var.admin_usr
  admin_password                  = var.admin_pwd
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.app_network_interface.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}