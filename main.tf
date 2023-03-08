terraform {
  required_version = ">= 0.13.00"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.46.0"
    }
  }
}

variable "targetSubscription"{
	type = string
}
variable "tenantID"{
	type = string
}
variable "deploymentAppID"{
	type = string
}
variable "deploymentSecret"{
	type = string
}

# Configure the provider
provider "azurerm" {
  features {}
  subscription_id = "${var.targetSubscription}"
  tenant_id       = "${var.tenantID}"
  client_id       = "${var.deploymentAppID}"
  client_secret   = "${var.deploymentSecret}"
}

resource "azurerm_resource_group" "example-rg" {
  name     = "example-resources"
  location = "Australia East"
}


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example-vnet" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example-rg.name
  location            = azurerm_resource_group.example-rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "example-snet" {
  name                 = "example-subnetname"
  resource_group_name  = azurerm_resource_group.example-rg.name
  virtual_network_name = azurerm_virtual_network.example-vnet.name
  address_prefixes     = ["10.0.2.0/24"]
  service_endpoints    = ["Microsoft.Sql", "Microsoft.Storage"]
}


#create a storage accoutn with public access to test tfsec
resource "azurerm_storage_account" "example-stor" {
  name                = "exstorageaccount1829"
  resource_group_name = azurerm_resource_group.example-rg.name

  location                 = azurerm_resource_group.example-rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Allow"
    ip_rules                   = ["0.0.0.0/0"]
    virtual_network_subnet_ids = [azurerm_subnet.example-snet.id]
  }

  tags = {
    environment = "staging"
  }
}

#invalid{
#}