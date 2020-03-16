resource "azurerm_virtual_network" "eventstore" {
  name                = module.virtual_network_eventstore_name.result
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.eventstore.name
}

resource "azurerm_subnet" "eventstore" {
  name                 = module.subnet_eventstore_name.result
  resource_group_name  = azurerm_resource_group.eventstore.name
  virtual_network_name = azurerm_virtual_network.eventstore.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_network_security_group" "eventstore" {
  name                = module.network_security_group_eventstore_name.result
  location            = var.location
  resource_group_name = azurerm_resource_group.eventstore.name
}

resource "azurerm_network_security_rule" "eventstore_ssh" {
  name                        = "SSH"
  priority                    = 111
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefixes     = ["${trim(data.http.myip.body, "\n")}/32"]
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.eventstore.name
  network_security_group_name = azurerm_network_security_group.eventstore.name
}

resource "azurerm_network_interface" "eventstore" {
  count               = var.eventstore_nodes
  name                = "${module.network_interface_eventstore_name.result}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.eventstore.name

  ip_configuration {
    name                          = "ipconfig-${count.index}"
    subnet_id                     = azurerm_subnet.eventstore.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.eventstore.*.id, count.index)
  }
}

resource "azurerm_network_interface_security_group_association" "eventstore" {
  count                     = var.eventstore_nodes
  network_interface_id      = element(azurerm_network_interface.eventstore.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.eventstore.id
}

resource "azurerm_public_ip" "eventstore" {
  count               = var.eventstore_nodes
  name                = "${module.public_ip_address_eventstore_name.result}-${count.index}"
  location            = var.location
  resource_group_name = azurerm_resource_group.eventstore.name
  domain_name_label   = "${module.vm_eventstore_name.result}-${count.index}"
  allocation_method   = "Static"
}

resource "azurerm_private_dns_zone" "eventstore" {
  name                = "private.dns"
  resource_group_name = azurerm_resource_group.eventstore.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "eventstore" {
  name                  = azurerm_virtual_network.eventstore.name
  resource_group_name   = azurerm_resource_group.eventstore.name
  private_dns_zone_name = azurerm_private_dns_zone.eventstore.name
  virtual_network_id    = azurerm_virtual_network.eventstore.id
}

resource "azurerm_private_dns_a_record" "eventstore" {
  name                = "eventstore"
  records             = azurerm_network_interface.eventstore.*.private_ip_address
  resource_group_name = azurerm_resource_group.eventstore.name
  ttl                 = 300
  zone_name           = azurerm_private_dns_zone.eventstore.name
}
