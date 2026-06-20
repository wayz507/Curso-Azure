##### 0 - Variables - Configuración general de Azure #####
subscription_id = "ab40ebfc-f6bc-456d-aea4-318dc3c9836c"
user_object_id  = "" # Reemplaza con el Object ID real del usuario o grupo
##### Variables - Configuración de despliegue y etiquetado #####
environment = "dev"
tags = {
  owner = "Carlos Solis"
}

##### Variables - Resource Group RAC #####
resource_group_name = "rg-utpdavid2026-user8-cc"
location            = "eastus2"

##### Variables - Storage Account RAC #####
storage_account_name  = ""
container_name        = ""
container_access_type = "private" #

##### Variables - Key Vault del RAC #####
key_vault_name = ""
key_vault_sku  = "standard" # ejemplo: "standard"


##### Variables - Azure AI Services (Cognitive) #####
ai_services_name                  = ""
ai_services_custom_subdomain_name = ""

##### Variables - Azure OpenAI (modelo) #####
openai_deployment_name = "gpt5nano"
openai_model_name      = "gpt-5-nano"
openai_model_version   = "2025-08-07"
openai_scale_capacity  = 1

##### Variables - Azure AI Foundry (Hub/Proj) #####
ai_foundry_hub_name     = ""
ai_foundry_project_name = ""
