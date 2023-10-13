/**
 * Private DNS zone for servicing Azure Database for PostgreSQL Flexible Server 
 * requests within a virtual network.
 */
resource "azurerm_private_dns_zone" "dnszn" {
	name                = "fs.postgres.database.azure.com"
	resource_group_name = azurerm_resource_group.rg-main.name

	tags = local.tags
}

/**
 * Link the private DNS zone to the virtual network.
 */
resource "azurerm_private_dns_zone_virtual_network_link" "dnsznlnk" {
	name                  = "dnsznlnk-${var.project-abbrev}-pgfs"
	private_dns_zone_name = azurerm_private_dns_zone.dnszn.name
	virtual_network_id    = azurerm_virtual_network.vnet.id
	resource_group_name   = azurerm_resource_group.rg-main.name
}