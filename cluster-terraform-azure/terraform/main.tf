resource "azurerm_resource_group" "eventstore" {
  name     = module.resource_group_eventstore_name.result
  location = local.location
}
