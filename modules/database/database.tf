#Creating storage account
resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#Create sql server connection with right subnet
resource "azurerm_sql_virtual_network_rule" "sql_database_connection" {
  name                = "example-vnet-rule"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mssql_server.my_sql_server.name
  subnet_id           = var.subnet_id
}

#create mysql server
resource "azurerm_mssql_server" "my_sql_server" {
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}


#Create sql server database
resource "azurerm_mssql_database" "devops_database_sql" {
  name           = var.sql_database_name
  server_id      = azurerm_mssql_server.my_sql_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 4
  read_scale     = true
  sku_name       = "S0"
  zone_redundant = true

  lifecycle {
    prevent_destroy = false
  }
}

#Create sql server connection with storage
resource "azurerm_storage_container" "backup_container" {
  name                  = "sqlbackups"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}

#Create SAS token to sql server access the storage account
data "azurerm_storage_account_sas" "sas" {
  connection_string = azurerm_storage_account.storage_account.primary_connection_string
  https_only        = true
  signed_version    = "2017-07-29"

  resource_types {
    service   = true
    container = false
    object    = false
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = "2018-03-21T00:00:00Z"
  expiry = "2020-03-21T00:00:00Z"

  permissions {
    read    = true
    write   = true
    delete  = false
    list    = false
    add     = true
    create  = true
    update  = false
    process = false
    tag     = false
    filter  = false
  }
} 
