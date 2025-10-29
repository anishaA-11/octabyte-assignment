####################################################
# AZURE INFRASTRUCTURE FOR OCTABYTE PROJECT
####################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  required_version = ">= 1.3.0"

  backend "local" {
    path = "./terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

####################################################
# RESOURCE GROUP
####################################################

resource "azurerm_resource_group" "rg" {
  name     = "octabyte-rg"
  location = var.location
}

####################################################
# VIRTUAL NETWORK & SUBNETS
####################################################

resource "azurerm_virtual_network" "vnet" {
  name                = "octabyte-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "public" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "private" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

####################################################
# NETWORK SECURITY GROUP
####################################################

resource "azurerm_network_security_group" "nsg" {
  name                = "octabyte-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "allow_ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow_http"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

####################################################
# NETWORK INTERFACE
####################################################

resource "azurerm_network_interface" "nic" {
  name                = "octabyte-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public.id
  }
}

####################################################
# PUBLIC IP
####################################################

resource "azurerm_public_ip" "public" {
  name                = "octabyte-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

####################################################
# LINUX VIRTUAL MACHINE
####################################################

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "octabyte-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  size                = "Standard_B1s"
  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
}

####################################################
# POSTGRESQL DATABASE
####################################################

resource "azurerm_postgresql_flexible_server" "db" {
  name                   = "octabyte-db"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  administrator_login    = var.db_username
  administrator_password = var.db_password
  sku_name               = "B_Standard_B1ms"
  storage_mb             = 32768

  authentication {
    password_auth_enabled = true
  }
}

####################################################
# LOAD BALANCER
####################################################

resource "azurerm_lb" "lb" {
  name                = "octabyte-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Basic"

  frontend_ip_configuration {
    name                 = "PublicIPConfig"
    public_ip_address_id = azurerm_public_ip.public.id
  }
}
