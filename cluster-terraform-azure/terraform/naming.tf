locals {
  naming_prefixes = var.naming_prefixes
  naming_suffixes = [random_string.suffix.result]
  location        = var.location
}

resource "random_string" "suffix" {
  length  = 13
  upper   = false
  special = false
  keepers = {
    location = var.location
  }
}

module "resource_group_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/resource_group"
  name     = "group"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "subnet_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/subnet"
  name     = "subnet"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "virtual_network_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/virtual_network"
  name     = "vnet"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "network_security_group_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/network_security_group"
  name     = "nsg"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "network_interface_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/network_interface"
  name     = "nic"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "public_ip_address_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/networking/public_ip_address"
  name     = "ip"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "availability_set_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/general/availability_set"
  name     = "set"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}

module "vm_eventstore_name" {
  source   = "gsoft-inc/naming/azurerm//modules/compute/vm_linux"
  name     = "vm"
  prefixes = local.naming_prefixes
  suffixes = local.naming_suffixes
}
