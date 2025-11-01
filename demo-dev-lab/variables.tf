variable "name_prefix" {  
    description = "Prefix for the name of the resources"  
    type        = string  
}
variable "location" {  
    description = "The Azure location to deploy the resources"
    type        = string  
}
variable "rgname" {  
    description = "The name of the resource group"  
    type        = string  
}
variable "virtual_network_address_space" {
    description = "The CIDR prefix for the virtual network. This should be at least a /22. Example 10.0.0.0/22"
    type        = list(string)
}
variable "virtual_network_address_name" {
    description = "The name of the virtual network."
    type        = string
}
variable "virtual_network_subnet_name" {
    description = "The name of the virtual network subnet."
    type        = string
}
variable "storage_account_name_prefix" {
    description = "The Storage Account Name"
    type        = string
}
variable "tags" {
  type = map(string)
  default = {
    "environment" = "demo-dev-lab",
    "owner"       = "lorenzo@m365x81069064.onmicrosoft.com",
    "managed_by"  = "terraform"
  }
}
variable "log_analytics_workspace_name" {
    description = "The Log Analytics Workspace Name"
    type        = string

}
