// VIRTUAL NETWORK
resource "azurerm_virtual_network" "vnet-itqueiroz-impacta-eastus-cloud" {
  name                = "vnet-itqueiroz-impacta-eastus-cloud"
  location            = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.location
  resource_group_name = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.name
  address_space       = ["10.0.0.0/16"]


  subnet {
     name                 = "subnet-1"
     address_prefix       = "10.0.1.0/24"
  }

  tags = {
    environment = "Impacta"
  }
}

//Firewall
resource "azurerm_network_security_group" "nsg-itqueiroz-impacta-eastus-cloud" {
  name                = "nsg-itqueiroz-impacta-eastus-cloud"
  location            = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.location
  resource_group_name = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Web"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Impacta"
  }
}

