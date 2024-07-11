variable "location" {
    type = string
}

variable "resource_group_name" {
    type = string
}

variable "storage_account_name" {
    default = "devopsstorage"
}

variable "sql_server_name" {
    default = "devopsdatabase"
}

variable "administrator_login" {
    default = "4dm1n157r470r"
}   

variable "administrator_login_password" {
    default = "4-v3ry-53cr37-p455w0rd"
}

variable "sql_database_name" {
    default = "devopssql"
}

variable "subnet_id" {
    type = string
}