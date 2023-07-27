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

#Create resource group for all other components
resource "azurerm_resource_group" "resourceGroup" {
  name     = var.resourceGroupName
  location = var.location
}

#create virtual network & subnets for database and function app
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

#create sql server to host sql database
resource "azurerm_sql_server" "sqlServer" {
  name = var.sqlServerName
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location = azurerm_resource_group.resourceGroup.location
  administrator_login = var.sqlServer_admin
  administrator_login_password = var.sqlServer_password
}

#create sql databse
resource "azurerm_sql_database" "db" {
  name                = var.databaseName
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location
  server_name         = azurerm_sql_server.sqlServer.name
}

#create app service plan to host azure function app
resource "azurerm_app_service_plan" "appServicePlan" {
  name                = var.appServicePlan
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}

#create storage account as a pre-requisite for function app
resource "azurerm_storage_account" "storageAccount" {
  name                     = "var.storageAccountName"
  resource_group_name      = azurerm_resource_group.resourceGroup.name
  location                 = azurerm_resource_group.resourceGroup.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

#create azure function app for the Front end
resource "azurerm_function_app" "app" {
  name                       = var.appName
  location                   = azurerm_resource_group.resource_group.location
  resource_group_name        = azurerm_resource_group.resource_group.name
  app_service_plan_id        = azurerm_app_service_plan.appServicePlan.id
  storage_account_name       = azurerm_storage_account.storageAccount.name
  storage_account_access_key = azurerm_storage_account.storageAccount.primary_access_key
}
