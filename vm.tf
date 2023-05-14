// IP PÚBLICO
resource "azurerm_public_ip" "ip-itqueiroz-impacta-eastus-cloud" {
  name                = "ip-itqueiroz-impacta-eastus-cloud"
  resource_group_name = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.name
  location            = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.location
  allocation_method   = "Static"

  tags = {
    environment = "Impacta"
  }
}

//NETWORK INTERFACE
resource "azurerm_network_interface" "ni-itqueiroz-impacta-eastus-cloud" {
  name                = "ni-itqueiroz-impacta-eastus-cloud"
  resource_group_name = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.name
  location            = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_virtual_network.vnet-itqueiroz-impacta-eastus-cloud.subnet.*.id[0]
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.ip-itqueiroz-impacta-eastus-cloud.id
  }
}

//VIRTUAL MACHINE
resource "azurerm_linux_virtual_machine" "vm-itqueiroz-impacta-eastus-cloud" {
  name                            = "vm-itqueiroz-impacta-eastus-cloud"
  resource_group_name             = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.name
  location                        = azurerm_resource_group.rg-itqueiroz-impacta-eastus-cloud.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Teste@12345"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ni-itqueiroz-impacta-eastus-cloud.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }


}

//Associar o firewall a placa de rede
resource "azurerm_network_interface_security_group_association" "nic-nsg-itqueiroz-impacta-eastus-cloud" {
  network_interface_id      = azurerm_network_interface.ni-itqueiroz-impacta-eastus-cloud.id
  network_security_group_id = azurerm_network_security_group.nsg-itqueiroz-impacta-eastus-cloud.id
}


resource "null_resource" "install-nginx" {
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      host     = azurerm_public_ip.ip-itqueiroz-impacta-eastus-cloud.ip_address
      user     = "adminuser"
      password = "Teste@12345"
    }

    inline = [
      "sudo apt update",
      "sudo apt -y install nginx"
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.vm-itqueiroz-impacta-eastus-cloud
  ]
}
