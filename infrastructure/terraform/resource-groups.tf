resource "azurerm_resource_group" "rg-main" {
	name     = "rg-main"
	location = "centralus"
	tags     = local.tags
}