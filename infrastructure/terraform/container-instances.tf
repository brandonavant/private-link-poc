/**
 * Container group which provides a container instance that shall be used as a jumpbox
 * into the VNET, thus providing access to private resources within the VNET.
 */
resource "azurerm_container_group" "acg" {
  name                = "acg-${var.project-abbrev}-jumpbox"
  location            = azurerm_resource_group.rg-main.location
  resource_group_name = azurerm_resource_group.rg-main.name
  os_type             = "Linux"
  restart_policy      = "Always"
  subnet_ids          = [azurerm_subnet.snet-acg.id]
  ip_address_type     = "Private"

  container {
    name   = "container-${var.project-abbrev}-jumpbox-1"
    image  = "ubuntu:latest"
    cpu    = 1
    memory = 2

    commands = [
      "/bin/sh",
      "-c",
      "tail -f /dev/null"
    ]

    ports {
      port     = "22"
      protocol = "TCP"
    }
  }
	
  depends_on = [azurerm_subnet.snet-acg]

  tags = local.tags
}