variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
}

variable "vnet_name" {
  description = "Name of the Azure virtual network"
  type        = string
}

variable "web_subnet_name" {
  description = "Name of the web subnet"
  type        = string
}

variable "db_subnet_name" {
  description = "Name of the database subnet"
  type        = string
}

variable "web_server_count" {
  description = "Number of web servers to create"
  type        = number
}

variable "web_server_size" {
  description = "Size of the web servers"
  type        = string
}

variable "db_server_count" {
  description = "Number of database servers to create"
  type        = number
}

variable "db_server_size" {
  description = "Size of the database servers"
  type        = string
}
