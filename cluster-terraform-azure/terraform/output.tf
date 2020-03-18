output "node_fqdn" {
  value = azurerm_public_ip.eventstore.*.fqdn
}

output "cluster_fqdn" {
  value = "${azurerm_private_dns_a_record.eventstore.name}.${azurerm_private_dns_a_record.eventstore.zone_name}"
}
