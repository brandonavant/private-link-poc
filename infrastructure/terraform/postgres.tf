/**
 * Randomly-generated password for the PostgreSQL server.
 */
resource "random_password" "postgres_password" {
	length           = 16
	special          = true
	override_special = "_%@"
}

/**
 * Azure Database for PostgreSQL Flexible Server instance.
 */
resource "azurerm_postgresql_flexible_server" "pgfs" {
	name                   = "pgfs-${var.project-abbrev}"
	resource_group_name    = azurerm_resource_group.rg-main.name
	location               = azurerm_resource_group.rg-main.location
	version                = "15"
	delegated_subnet_id    = azurerm_subnet.snet-pgfs.id
	private_dns_zone_id    = azurerm_private_dns_zone.dnszn.id
	administrator_login    = "psqladmin"
	administrator_password = random_password.postgres_password.result
	zone                   = "1"
	storage_mb             = 32768
	sku_name               = "B_Standard_B1ms"
	depends_on             = [azurerm_private_dns_zone_virtual_network_link.dnsznlnk]
	tags                   = local.tags
}

/**
 * Output the randomly-generated password for the PostgreSQL server. We are doing this in this PoC; however, you should
 * not do this in a production environment. Instead, you should use a secret store such as Azure Key Vault.
 */
output "pgfs-admin-password" {
	value     = random_password.postgres_password.result
	sensitive = true // Use "terraform output -json" to see the value
}