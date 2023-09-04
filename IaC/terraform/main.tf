provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "ivans-iac-example777"
  location = "West US"
}

resource "azurerm_windows_function_app" "example" {
  name                      = "visitcounterapp777"
  location                  = azurerm_resource_group.example.location
  resource_group_name       = azurerm_resource_group.example.name
  
  service_plan_id       = azurerm_service_plan.example.id
  storage_account_name   = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key

  app_settings = {
    "FUNCTIONS_WORKER_RUNTIME" = "dotnet"
  }

  site_config {}
}

resource "azurerm_service_plan" "example" {
  name                = "ivansfunction-appserviceplan"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  os_type             = "Windows"
  sku_name            = "Y1"
}

// Create a Storage Account to host the static website & for the function app to use
resource "azurerm_storage_account" "example" {
  name                     = "ivansitestore777"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document = "index.html"
    error_404_document = "404.html"
  }
}