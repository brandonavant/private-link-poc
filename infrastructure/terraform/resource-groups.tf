resource "azurerm_resource_group" "rg-main" {
	name     = "rg-${var.project-abbrev}"
	location = "centralus"
	tags     = local.tags
}