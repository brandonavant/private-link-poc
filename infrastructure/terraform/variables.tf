/**
 * Variable used to define the project abbreviation. This will be used throughout the project to name resources.
 */
variable "project-abbrev" {
	description = "Project abbreviation used when naming resources."
	type        = string
	default     = "pgprivendpt"
}

/**
 * IP range for the virtual network.
 */
variable "vnet-address-space" {
	description = "The IP range for the virtual network."
	type        = string
	default     = "10.0.0.0/16"
}

/**
 * IP range for the private endpoint subnet.
 */
variable "snet-pgfs-address-prefix" {
	description = "The IP range for the private endpoint subnet."
	type        = string
	default     = "10.0.1.0/24"
}

/**
 * IP range for the container subnet.
 */
variable "snet-acg-address-space" {
	description = "The IP range for the container subnet."
	type        = string
	default     = "10.0.2.0/24"
}