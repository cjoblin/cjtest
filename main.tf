terraform {
  required_version = ">= 0.13.00"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.9.0"
    }
  }
}

# Configure the provider
provider "azurerm" {
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "Australia East"
}


# Create a virtual network within the resource group
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/1"]
}

invalid{
}