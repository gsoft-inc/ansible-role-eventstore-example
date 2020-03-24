resource "azurerm_availability_set" "eventstore" {
  name                = module.availability_set_eventstore_name.result
  resource_group_name = azurerm_resource_group.eventstore.name
  location            = var.location
}

resource "azurerm_linux_virtual_machine" "eventstore" {
  count                 = var.eventstore_nodes
  name                  = "${module.vm_eventstore_name.result}-${count.index}"
  resource_group_name   = azurerm_resource_group.eventstore.name
  location              = var.location
  size                  = var.eventstore_vm_size
  admin_username        = "adminuser"
  network_interface_ids = [element(azurerm_network_interface.eventstore.*.id, count.index)]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "None"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
