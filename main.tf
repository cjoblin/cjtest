# Configure the provider
provider "azurerm" {
  version = "=4.20.0"
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
  address_space       = ["10.0.0.0/16"]
}

invalid{
}