terraform {
  required_providers {
    netbox = {
      source  = "e-breuninger/netbox"
      version = "3.10.0"
    }
  }
}

# These are read from the environment
provider "netbox" {
  # server_url = "" NETBOX_SERVER_URL
  # api_token= "" NETBOX_API_TOKEN
}