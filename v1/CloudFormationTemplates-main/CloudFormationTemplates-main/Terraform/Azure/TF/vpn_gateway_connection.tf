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
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_virtual_wan" "example" {
  name                = "example-vwan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_virtual_hub" "example" {
  name                = "example-hub"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  virtual_wan_id      = azurerm_virtual_wan.example.id
  address_prefix      = "10.0.0.0/24"
}

resource "azurerm_vpn_gateway" "example" {
  name                = "example-vpng"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  virtual_hub_id      = azurerm_virtual_hub.example.id
}

resource "azurerm_vpn_site" "example" {
  name                = "example-vpn-site"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  virtual_wan_id      = azurerm_virtual_wan.example.id
  link {
    name       = "link1"
    ip_address = "10.1.0.0"
  }
  link {
    name       = "link2"
    ip_address = "10.2.0.0"
  }
}

resource "azurerm_vpn_gateway_connection" "example" {
  name               = "example"
  vpn_gateway_id     = azurerm_vpn_gateway.example.id
  remote_vpn_site_id = azurerm_vpn_site.example.id

  vpn_link {
    name             = "link1"
    vpn_site_link_id = azurerm_vpn_site.example.link[0].id
  }

  vpn_link {
    name             = "link2"
    vpn_site_link_id = azurerm_vpn_site.example.link[1].id
  }
}