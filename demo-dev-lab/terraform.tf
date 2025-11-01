
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
    subscription_id = "1dd93b0d-9968-4d42-8d5b-510d621c7866"
    tenant_id       = "70af9f5c-0065-4148-8b47-3b5073308d2c"
    resource_provider_registrations = "core"  
    resource_providers_to_register  = ["Microsoft.OperationalInsights"]  
    storage_use_azuread             = true
}