output "vm_public_ip" {
  description = "Public IP of the VM"
  value       = azurerm_public_ip.public.ip_address
}

output "database_fqdn" {
  description = "PostgreSQL Database FQDN"
  value       = azurerm_postgresql_flexible_server.db.fqdn
}

output "resource_group" {
  description = "Resource Group Name"
  value       = azurerm_resource_group.rg.name
}
