
terraform {  
    required_version = ">= 1.10"  
    required_providers {    
        azurerm = {      
            source  = "hashicorp/azurerm"      
            version = "~> 4.21"    
        }
        random = {
            source  = "hashicorp/random"
            version = "3.7.2"
        }
    }
}


provider "azurerm" {  
    features {}
    subscription_id = "1ef93b9d-7268-4a12-8d5b-510d621cbfe1"
    tenant_id       = "30af7de5-0a65-9348-8fc2-3b5079808d2d"
    resource_provider_registrations = "core"  
    resource_providers_to_register  = ["Microsoft.OperationalInsights"]  
    storage_use_azuread             = true

}
