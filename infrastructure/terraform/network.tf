/**
 * Primary virtual network.
 */
resource "azurerm_virtual_network" "vnet" {
	address_space       = [var.vnet-address-space]
	location            = azurerm_resource_group.rg-main.location
	name                = "vnet-${var.project-abbrev}"
	resource_group_name = azurerm_resource_group.rg-main.name
	tags                = local.tags
}

/**
 * Subnet for the PostgreSQL Flexible Server.
 */
resource "azurerm_subnet" "snet-pgfs" {
	address_prefixes     = [var.snet-pgfs-address-prefix]
	name                 = "snet-pgfs-${var.project-abbrev}"
	resource_group_name  = azurerm_resource_group.rg-main.name
	virtual_network_name = azurerm_virtual_network.vnet.name
	service_endpoints    = ["Microsoft.Storage"]

	delegation {
		name = "snet-pgfs-${var.project-abbrev}-delegation"
		service_delegation {
			name    = "Microsoft.DBforPostgreSQL/flexibleServers"
			actions = [
				"Microsoft.Network/virtualNetworks/subnets/join/action",
			]
		}
	}
}

/**
 * Subnet for the Azure Container Group.
 */
resource "azurerm_subnet" "snet-acg" {
	address_prefixes     = [var.snet-acg-address-space]
	name                 = "snet-acg-${var.project-abbrev}"
	resource_group_name  = azurerm_resource_group.rg-main.name
	virtual_network_name = azurerm_virtual_network.vnet.name

	delegation {
		name = "snet-acg-${var.project-abbrev}-delegation"

		service_delegation {
			actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
			name    = "Microsoft.ContainerInstance/containerGroups"
		}
	}
}