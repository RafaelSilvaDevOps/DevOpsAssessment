resource "azurerm_resource_group" "resource_group" {
    name = var.resource_group_name
    location = var.location
}

module "virtual_machine" {
    source = "./modules/virtual_machine"
    resource_group_name = var.resource_group_name
    location = var.location
    depends_on = [ azurerm_resource_group.resource_group ]
}

module "database" {
    source = "./modules/database"
    resource_group_name = var.resource_group_name
    location = var.location
    subnet_id = module.virtual_machine.subnet_id
    depends_on = [ azurerm_resource_group.resource_group ]
}