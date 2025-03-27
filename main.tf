terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "3.10.0"
    }
  }
}

terraform {
  backend "azurerm" {
    storage_account_name = "tgtech"
    container_name       = "tfstate"
    key                  = "tg25-netbox/terraform.state"
  }
}

# These are read from the environment
provider "netbox" {
  # server_url = "" NETBOX_SERVER_URL
  # api_token= "" NETBOX_API_TOKEN
}