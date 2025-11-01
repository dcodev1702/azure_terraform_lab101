# Azure Terraform Infrastructure with Azure Verified Modules (AVM)

This repository contains Terraform configuration for deploying Azure infrastructure using Azure Verified Modules (AVM), providing a standardized and Microsoft-supported approach to infrastructure as code.

## 📚 Documentation Resources

### Azure Verified Modules (AVM)
- **AVM Portal**: https://aka.ms/avm
- **AVM Terraform Solution Development Guide**: https://azure.github.io/Azure-Verified-Modules/usage/solution-development/terraform/
- **AVM Terraform Quickstart**: https://azure.github.io/Azure-Verified-Modules/usage/quickstart/terraform/
- **AVM Terraform Module Index**: https://azure.github.io/Azure-Verified-Modules/indexes/terraform/
- **AVM GitHub Repository**: https://github.com/Azure/Azure-Verified-Modules

### Terraform AzAPI Provider 2.0
- **AzAPI Provider Documentation**: https://registry.terraform.io/providers/Azure/azapi/latest/docs
- **AzAPI Provider GitHub**: https://github.com/Azure/terraform-provider-azapi
- **AzAPI 2.0 Upgrade Guide**: https://registry.terraform.io/providers/Azure/azapi/latest/docs/guides/2.0-upgrade-guide
- **Microsoft Learn - AzAPI Overview**: https://learn.microsoft.com/en-us/azure/developer/terraform/overview-azapi-provider
- **AzAPI Quickstart**: https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-azapi-resource

### Terraform Module Registry
- **Terraform Registry**: https://registry.terraform.io
- **Search for AVM modules**: https://registry.terraform.io/search/modules?q=avm

## 🎯 Infrastructure Overview

This Terraform configuration deploys a comprehensive Azure infrastructure using Azure Verified Modules, including:

- **Resource Group**: Container for all resources
- **Virtual Network**: With address space management and subnet configuration
- **Storage Account**: 
  - With private endpoint connectivity
  - Blob container for demo purposes
  - Diagnostic settings integration
- **Log Analytics Workspace**: For centralized monitoring and diagnostics
- **Private DNS Zone**: For private endpoint resolution (blob.core.windows.net)
- **IP Address Management**: Automated subnet CIDR calculation using AVM utility module

## ✅ Prerequisites & Assumptions

### Required Azure Resources
1. **Azure Tenant and Subscription**
   - Active Azure subscription with appropriate permissions
   - Tenant ID for authentication (example: 12345678-1234-1234-1234-123456789abc)

2. **Permissions**
   - Contributor or Owner role on the subscription
   - Ability to create resources in the target Azure subscription
   - Rights to create Service Principals (if using service principal authentication)
   - Microsoft.OperationalInsights resource provider registration permissions

### Technical Requirements
1. **Terraform CLI**
   - Version 1.10 or higher
   - Installation: `winget install hashicorp.terraform` (Windows) or [download](https://www.terraform.io/downloads)
   ```powershell
     $PathValue = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::Machine)
     $NewPath = $PathValue.Replace(";C:\Terraform","")
     [System.Environment]::SetEnvironmentVariable("PATH", $NewPath, [System.EnvironmentVariableTarget]::Machine)
   ```

2. **Azure CLI**
   - Latest version for authentication
   - Installation: `winget install Microsoft.AzureCLI` (Windows) or [download](https://docs.microsoft.com/cli/azure/install-azure-cli)

3. **Code Editor** (Recommended)
   - Visual Studio Code with extensions:
     - HashiCorp Terraform (`hashicorp.terraform`)
     - Azure Terraform (`ms-azuretools.vscode-azureterraform`)
   ```powershell
     code --install-extension "hashicorp.terraform"
     code --install-extension "ms-azuretools.vscode-azureterraform"
   ```

### Knowledge Prerequisites
- Basic familiarity with programming concepts
- Understanding of Infrastructure as Code principles
- Basic knowledge of Azure resources (resource groups, networks, storage)
- Familiarity with Git for version control

## 🚀 Getting Started

### 1. Clone or Download the Repository

```bash
# Option 1: Clone via Git
git clone https://github.com/dcodev1702/azure_terraform_lab101.git
cd azure_terraform_lab101

# Option 2: Download ZIP
# Download and extract the repository ZIP file
```

### 2. Set Up Your Local Environment

```bash
# Create a working directory (if not cloning)
mkdir ~/terraform-azure-avm
cd ~/terraform-azure-avm

# Copy all configuration files to your working directory
# Ensure you have: main.tf, variables.tf, terraform.tf, terraform.tfvars
```

### 3. Configure Azure Authentication

```bash
# Login to Azure (with device code for better security)
# Replace with your actual tenant ID
az login -t "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee" --use-device-code

# Set your subscription
az account set --subscription $(az account show --query id -o tsv)

# Export subscription ID for Terraform
export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
```

For Windows PowerShell:
```powershell
$env:ARM_SUBSCRIPTION_ID = $(az account show --query id -o tsv)
```

### 4. Configure Your Variables

Edit `terraform.tfvars` with your specific values:

```hcl
# Network configuration
virtual_network_address_space  = ["10.0.0.0/16"]  # Minimum /22 required
virtual_network_address_name   = "vnet-demo-dev"
virtual_network_subnet_name    = "subnet-demo-dev"

# Storage configuration
storage_account_name_prefix = "stdev"  # Must be 3-11 characters, lowercase

# Monitoring
log_analytics_workspace_name = "law-demo-dev"

# Optional: Override default values
location = "canadacentral"  # or your preferred Azure region
rgname   = "rg-demo-dev"    # your resource group name

# Tags (customize as needed)
tags = {
  environment = "demo-dev-lab"
  owner       = "user@example.com"
  project     = "avm-infrastructure"
  managed_by  = "terraform"
}
```

### 5. Initialize and Deploy

```bash
# Initialize Terraform and download AVM modules
terraform init

# Format your configuration files
terraform fmt

# Review the planned changes
terraform plan -out=tfplan

# Apply the configuration
terraform apply tfplan
```

## 🛠️ Working with the Configuration

### Validating Your Configuration
```bash
# Check for syntax errors
terraform validate

# Preview changes without applying
terraform plan
```

### Managing State
- The Terraform state file (`terraform.tfstate`) contains sensitive information
- Never commit state files to version control
- Consider using remote state storage (Azure Storage Account with backend configuration)

### Updating Infrastructure
```bash
# After making changes to .tf files
terraform plan -out=tfplan
terraform apply tfplan
```

### Destroying Infrastructure
```bash
# Remove all created resources
terraform destroy

# Or create a destroy plan first
terraform plan -destroy -out=destroyplan
terraform apply destroyplan
```

## 📦 Module Details

### Azure Verified Modules Used

| Module | Version | Purpose |
|--------|---------|---------|
| [Azure/avm-res-resources-resourcegroup/azurerm](https://registry.terraform.io/modules/Azure/avm-res-resources-resourcegroup/azurerm/latest) | 0.2.1 | Resource Group management |
| [Azure/avm-utl-network-ip-addresses/azurerm](https://registry.terraform.io/modules/Azure/avm-utl-network-ip-addresses/azurerm/latest) | 0.1.0 | IP address calculation utility |
| [Azure/avm-res-network-virtualnetwork/azurerm](https://registry.terraform.io/modules/Azure/avm-res-network-virtualnetwork/azurerm/latest) | 0.15.0 | Virtual Network and Subnets |
| [Azure/avm-res-network-privatednszone/azurerm](https://registry.terraform.io/modules/Azure/avm-res-network-privatednszone/azurerm/latest) | 0.4.0 | Private DNS Zone |
| [Azure/avm-res-storage-storageaccount/azurerm](https://registry.terraform.io/modules/Azure/avm-res-storage-storageaccount/azurerm/latest) | 0.6.4 | Storage Account with private endpoints |
| [Azure/avm-res-operationalinsights-workspace/azurerm](https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/latest) | 0.4.2 | Log Analytics Workspace |

### Finding Additional Modules
1. Search the Terraform Registry: https://registry.terraform.io/search/modules?q=avm
2. Browse the AVM catalog: https://azure.github.io/Azure-Verified-Modules/indexes/terraform/

## 🔒 Security Considerations

1. **Private Endpoints**: Storage account is secured with private endpoints
2. **Network Isolation**: Resources communicate through private network
3. **Diagnostic Logging**: All resources send logs to Log Analytics
4. **Git Security**: The `.gitignore` file excludes sensitive files like:
   - `terraform.tfstate`
   - `.terraform/` directory
   - `.terraform.lock.hcl` (optional)

## 🐛 Troubleshooting

### Common Issues

1. **Authentication Errors**
   ```bash
   # Ensure you're logged in
   az account show
   
   # Check subscription
   az account list --output table
   ```

2. **Provider Registration**
   ```bash
   # Register required providers
   az provider register --namespace Microsoft.OperationalInsights
   az provider register --namespace Microsoft.Storage
   az provider register --namespace Microsoft.Network
   ```

3. **Module Download Issues**
   ```bash
   # Clean and reinitialize
   rm -rf .terraform
   terraform init -upgrade
   ```

## 📈 Next Steps

1. **Add More Resources**: Browse AVM modules to add databases, compute, or other services
2. **Implement CI/CD**: Set up GitHub Actions or Azure DevOps pipelines
3. **Remote State**: Configure Azure Storage backend for state management
4. **Environment Separation**: Create separate configurations for dev, staging, and production

## 🤝 Contributing

When contributing to this repository:
1. Follow AVM module standards
2. Test all changes in a development environment
3. Update documentation for any new modules or variables
4. Use semantic versioning for releases

## 📝 License

[Specify your license here]

## 🆘 Support

- **AVM Issues**: https://github.com/Azure/Azure-Verified-Modules/issues
- **Terraform Documentation**: https://www.terraform.io/docs
- **Azure Documentation**: https://docs.microsoft.com/azure

## 🔗 Additional Resources

- [AVM Contribution Guide](https://azure.github.io/Azure-Verified-Modules/contributing/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)
- [Azure Well-Architected Framework](https://docs.microsoft.com/azure/architecture/framework/)
