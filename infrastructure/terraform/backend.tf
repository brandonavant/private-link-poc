terraform {

	/**
	 * This is the backend configuration for the terraform state file.
	 * It is stored in an Azure Storage Account.
	 */
	backend "azurerm" {
		container_name       = "terraform-state"
		key                  = "terraform.tfstate"
		resource_group_name  = "rg-pgprivendpt-tfstate"
		storage_account_name = "stpgprivendpttfstate"
	}
}