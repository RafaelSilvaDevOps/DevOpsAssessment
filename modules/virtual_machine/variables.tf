variable "vm_network_name" {
    default = "vm_network"
}

variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "nsg_name" {
    default = "devopsnsg"
}

variable "web_subnet_name" {
    default = "websubnet"
}

variable "database_subnet" {
    default = "databasesubnet"
}

variable "vm_subnet" {
    default = "vm_subnet"
}

variable "nic_name1" {
    default = "devops_nic"
}

variable "nic_name2" {
    default = "devops_nic_lb"
}

variable "virtual_machine_name1" {
    default = "devopslinux"
}

variable "virtual_machine_name2" {
    default = "devopslinuxLB"
}

variable "admin_name" {
    default = "devopsadm"
}

variable "lb_name" {
    default = "loadbalancer"
}

variable "public_ip_name" {
    default = "devopsIP"
}

variable "lb_address_name" {
    default = "loadbalancerip"
}

variable "ssh_key_name" {
    default = "sshdevops"
}

variable "vm_password1" {
    default = "Cfj8K6RxKT38zpNo"
}

variable "vm_password2" {
    default = "m16DhKnO9nLSJgYG"
}