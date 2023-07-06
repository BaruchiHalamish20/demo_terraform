
module "network" {
  source              = "./network"
  
  resource_group_name = "var.resource_group_name"
  #location            = var.location
  #vnet_name           = var.vnet_name
  #web_subnet_name     = var.web_subnet_name
  #db_subnet_name      = var.db_subnet_name
}

#module "servers" {
#  source              = "./servers"
#  resource_group_name = var.resource_group_name
#  location            = var.location
#  web_subnet_id       = module.network.web_subnet_id
#  db_subnet_id        = module.network.db_subnet_id
#  web_server_count    = var.web_server_count
#  web_server_size     = var.web_server_size
#  db_server_count     = var.db_server_count
#  db_server_size      = var.db_server_size
#}
