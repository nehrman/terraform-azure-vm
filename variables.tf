variable "tf_az_name" {
  description = "Name used to create all resources except subnets"
}

variable "tf_az_env" {
  description = "Environnement where the resources will be created"
}

variable "tf_az_location" {
  description = "The location/region where the core network will be created. The full list of Azure regions can be found at https://azure.microsoft.com/regions"
}

variable "tf_az_net_addr_space" {
  description = "The address space that is used by the virtual network."
  default     = "10.0.0.0/16"
}

# If no values specified, this defaults to Azure DNS 
variable "tf_az_dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

variable "tf_az_subnet_prefixes" {
  description = "The address prefix to use for the subnet."
  default     = ["10.0.1.0/24"]
}

variable "tf_az_subnet_names" {
  description = "A list of public subnets inside the vNet."
  default     = ["subnet1"]
}

variable "tf_az_storage_account_name" {
  description = "Name used to create the Storage Account."
}

variable "tf_az_storage_account_tier" {
  description = "The type of Storage account. Standard or Premium are only the two validated options."
  default     = "Standard"
}

variable "tf_az_storage_account_repl" {
  description = "The type of replication to use with the Storage account. Valid options are LRS, GRS, RAGRS and ZRS"
  default     = "LRS"
}

variable "tf_az_tags" {
  description = "The tags to associate with your network and subnets."
  type        = "map"
}
