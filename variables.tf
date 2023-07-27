variable "resourceGroupName" {
  description = "resource group name"
  type        = string
}
variable "location" {
  description = "location for resources"
  type        = string
}
variable "vnetName" {}
variable "vnetAddressSpace" {}
variable "web-subnet" {}
variable "webSubnetAddressSpace" {}
variable "app-subnet" {}
variable "appSubnetAddressSpace" {}
variable "dbSubnetAddressSpace" {}
variable "sqlServerName" {}
variable "sqlServer_admin" {}
variable "sqlServer_password" {}
variable "databaseName" {}
variable "appServicePlan" {}
variable "storageAccountName" {}
variable "appName" {}

