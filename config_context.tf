resource "netbox_config_context" "global_config" {
  name = "global-config"
  data = jsonencode(
    { "key" = "value" }
  )
}