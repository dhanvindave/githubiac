# 1. Specify the version of the AzureRM Provider to use
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.60.0"
    }
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  # The AzureRM Provider supports authenticating using via the Azure CLI, a Managed Identity
  # and a Service Principal. More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure

  # The features block allows changing the behaviour of the Azure Provider, more
  # information can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "database-rg"
  location = "West Europe"
}

resource "azurerm_mssql_server" "primary" {
  public_network_access_enabled = "false" 
  azuread_administrator =         {
            "login_username": "l"    
} 
  name                         = "mssqlserver-primary"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat11"
}

resource "azurerm_mssql_server" "secondary" {
  public_network_access_enabled = "false" 
  azuread_administrator =         {
            "login_username": "g"    
} 
  name                         = "mssqlserver-secondary"
  resource_group_name          = azurerm_resource_group.example.name
  location                     = azurerm_resource_group.example.location
  version                      = "12.0"
  administrator_login          = "missadministrator"
  administrator_login_password = "thisIsKat12"
}

resource "azurerm_mssql_database" "example" {
  geo_backup_enabled = "true" 
  storage_account_type = "Geo" 
  transparent_data_encryption_enabled = "true" 
  name        = "exampledb"
  server_id   = azurerm_mssql_server.primary.id
  sku_name    = "S1"
  collation   = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb = "200"
}

resource "azurerm_mssql_failover_group" "example" {
  name      = "example"
  server_id = azurerm_mssql_server.primary.id
  databases = [
    azurerm_mssql_database.example.id
  ]

  partner_server {
    id = azurerm_mssql_server.secondary.id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 80
  }

  tags = {
    environment = "prod"
    database    = "example"
  }
}