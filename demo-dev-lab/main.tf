
resource "random_string" "sa_name" {
  length  = 4
  special = false
  upper   = false
}

module "resource_group" {  
    source  = "Azure/avm-res-resources-resourcegroup/azurerm"
    version = "0.2.1"  
    location = var.location  
    name     = var.rgname
    tags     = var.tags
}


module "ip_addresses" {
  source  = "Azure/avm-utl-network-ip-addresses/azurerm"
  version = "0.1.0"
  
  address_space = var.virtual_network_address_space[0]
  address_prefixes = { 
    demo = 24
  }
}

# Creating a virtual network with a unique name, telemetry settings, and in the specified resource group and location.
module "vnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.15.0"
  location            = var.location
  parent_id           = module.resource_group.resource_id
  address_space       = var.virtual_network_address_space
  enable_telemetry    = true
  name                = var.virtual_network_address_name
  diagnostic_settings = local.diagnostic_settings
  tags                = var.tags
}

module "vnet_subnet" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm//modules/subnet"
  version = "0.15.0"
  parent_id = module.vnet.resource_id
  name = var.virtual_network_subnet_name
  address_prefixes = [module.ip_addresses.address_prefixes["demo"]]
}

module "private_dns_zone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.4.0"
  domain_name = "privatelink.blob.core.windows.net"
  parent_id   = module.resource_group.resource_id
  virtual_network_links = {
    vnetlink1 = {
      name   = "storage-account-${random_string.sa_name.result}-pe"
      vnetid = module.vnet.resource_id
      tags   = var.tags
    }
  }
  tags = var.tags
}

locals {
  storage_account = "${var.storage_account_name_prefix}${random_string.sa_name.result}"
}

module "storage_account" {
  source  = "Azure/avm-res-storage-storageaccount/azurerm"
  version = "0.6.4"
  location            = var.location
  name                = local.storage_account
  resource_group_name = module.resource_group.name
  diagnostic_settings_storage_account = local.diagnostic_settings
  diagnostic_settings_blob = local.diagnostic_settings
  containers = {
    demo = {
      name = "demo"
    }
  }
  private_endpoints = {
    primary = {
      private_dns_zone_resource_ids = [module.private_dns_zone.resource_id]
      subnet_resource_id            = module.vnet_subnet.resource_id
      subresource_name              = "blob"
    }
  }
  tags = var.tags
}

module "log_analytics_workspace" {
  source  = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version = "0.4.2"
  
  location = var.location
  name     = var.log_analytics_workspace_name
  resource_group_name = module.resource_group.name
  diagnostic_settings = local.diagnostic_settings
  tags     = var.tags
}

locals {
  diagnostic_settings = {
    sendToLogAnalytics = {
      name = "sendToLogAnalytics"
      workspace_resource_id = module.log_analytics_workspace.resource_id
    }
  }
}
