terraform {
  required_version = "1.5.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.5.0"
    }
  }
}

provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {}
}
resource "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnetName
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  address_space       = var.vnetAddressSpace
}

resource "azurerm_subnet" "web-subnet" {
  name                 = var.web-subnet
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  address_prefixes     = var.webSubnetAddressSpace
}

resource "azurerm_subnet" "app-subnet" {
  name                 = var.app-subnet
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  address_prefixes     = var.appSubnetAddressSpace
}

resource "azurerm_subnet" "db-subnet" {
  name                 = var.db-subnet
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  address_prefixes     = var.dbSubnetAddressSpace
}
resource "azurerm_sql_server" "sqlServer" {
  name = var.sqlServerName
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = azurerm_resource_group.resourceGroup.location
  administrator_login = var.sqlServer_admin
  administrator_login_password = var.sqlServer_password
}

resource "azurerm_sql_database" "db" {
  name                = var.databaseName
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  server_name         = azurerm_sql_server.sqlServer.name
}
