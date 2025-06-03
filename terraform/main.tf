# --- Provider Azure ---
provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
}
# --- Groupe de ressources ---
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# --- Réseau virtuel ---
resource "azurerm_virtual_network" "main" {
  name                = "cloud1-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
}

# --- Subnet ---
resource "azurerm_subnet" "main" {
  name                 = "cloud1-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# --- IP publique ---
resource "azurerm_public_ip" "main" {
  name                = "cloud1-publicip"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# --- Interface réseau ---
resource "azurerm_network_interface" "main" {
  name                = "cloud1-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "cloud1-ipcfg"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

# --- VM Linux Ubuntu ---
resource "azurerm_linux_virtual_machine" "main" {
  name                = "cloud1-vm"
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  size                = "Standard_B1s"  # Eligible à l'offre gratuite

  admin_username      = var.admin_username
  network_interface_ids = [azurerm_network_interface.main.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
  publisher = "Debian"
  offer     = "debian-11"
  sku       = "11"
  version   = "latest"
  }

  computer_name  = "cloud1vm"
  disable_password_authentication = true

  tags = {
    env = "dev"
    managed_by = "terraform"
  }
}
