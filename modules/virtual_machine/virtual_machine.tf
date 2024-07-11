#Network Security Group
resource "azurerm_network_security_group" "nsg_devops" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "devopsaccess"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#Virtual Network
resource "azurerm_virtual_network" "vm_network" {
    name = var.vm_network_name
    address_space = ["10.0.0.0/16"]
    location = var.location
    resource_group_name = var.resource_group_name
}

#Virtual subnets
resource "azurerm_subnet" "vm_subnet" {
    name = var.vm_subnet
    resource_group_name = var.resource_group_name
    virtual_network_name = var.vm_network_name
    address_prefixes = [ "10.0.2.0/24" ]
}

resource "azurerm_subnet" "web_subnet" {
    name = var.web_subnet_name
    resource_group_name = var.resource_group_name
    virtual_network_name = var.vm_network_name
    address_prefixes = [ "10.0.3.0/24" ]
}

resource "azurerm_subnet" "database_subnet" {
    name = var.database_subnet
    resource_group_name = var.resource_group_name
    virtual_network_name = var.vm_network_name
    address_prefixes = [ "10.0.4.0/24" ]
}

# Associate NSG with Subnets
resource "azurerm_subnet_network_security_group_association" "vm_subnet_nsg" {
  subnet_id                 = azurerm_subnet.vm_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_devops.id
}

resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg" {
  subnet_id                 = azurerm_subnet.web_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_devops.id
}

resource "azurerm_subnet_network_security_group_association" "database_subnet_nsg" {
  subnet_id                 = azurerm_subnet.database_subnet.id
  network_security_group_id = azurerm_network_security_group.nsg_devops.id
}

#Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

#VMs NICs
resource "azurerm_network_interface" "vm_interface1" {
    name = var.nic_name1
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
      name = "devopsnicip"
      subnet_id = azurerm_subnet.vm_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}

resource "azurerm_network_interface" "vm_interface2" {
    name = var.nic_name2
    location = var.location
    resource_group_name = var.resource_group_name

    ip_configuration {
      name = "devopsniclbip"
      subnet_id = azurerm_subnet.vm_subnet.id
      private_ip_address_allocation = "Dynamic"
    }
}

#Virtual Machine 1
resource "azurerm_linux_virtual_machine" "devops_vm1" {
    name = var.virtual_machine_name1
    resource_group_name = var.resource_group_name
    location = var.location
    size = "Standard_F2"
    admin_username = "adminuser"
    disable_password_authentication = false 
    admin_password = var.vm_password1
    

    network_interface_ids = [ 
        azurerm_network_interface.vm_interface1.id
    ]

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts"
      version = "latest"
    }
}

#Virtual Machine 2
resource "azurerm_linux_virtual_machine" "devops_vm2" {
    name = var.virtual_machine_name2
    resource_group_name = var.resource_group_name
    location = var.location
    size = "Standard_F2"
    admin_username = "lbadminuser"
    admin_password = var.vm_password2
    disable_password_authentication = false

    network_interface_ids = [ 
        azurerm_network_interface.vm_interface2.id
    ]

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "Standard_LRS"
    }

    source_image_reference {
      publisher = "Canonical"
      offer = "0001-com-ubuntu-server-jammy"
      sku = "22_04-lts"
      version = "latest"
    }
}

#Load Balancer
resource "azurerm_lb" "load_balancer" {
  name                = var.lb_name
  resource_group_name = var.resource_group_name
  location            = var.location

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_lb_backend_address_pool" "lb_address" {
  loadbalancer_id = azurerm_lb.load_balancer.id
  name            = var.lb_address_name
}

resource "azurerm_availability_set" "lb_avaliability" {
  name                = "lbavaliability"
  location            = var.location
  resource_group_name = var.resource_group_name
}


# VM 1 Load Balancer configuration
resource "azurerm_network_interface_backend_address_pool_association" "vm1_association" {
  network_interface_id    = azurerm_network_interface.vm_interface1.id
  ip_configuration_name   = azurerm_network_interface.vm_interface1.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address.id
}

# VM 2 Load Balancer configuration
resource "azurerm_network_interface_backend_address_pool_association" "vm2_association" {
  network_interface_id    = azurerm_network_interface.vm_interface2.id
  ip_configuration_name   = azurerm_network_interface.vm_interface2.ip_configuration[0].name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb_address.id
}