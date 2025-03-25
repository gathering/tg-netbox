locals {
  templates_content = {
    for file in fileset("templates", "*") :
    file => file("${path.module}/templates/${file}")
  }
}

resource "netbox_config_template" "junos_non_els" {
  for_each = local.templates_content

  name               = each.key
  description        = "Template file loaded from github.com/gathering/tg25-netbox"
  template_code      = each.value
  environment_params = jsonencode({ trim_blocks = true, lstrip_blocks = true })
}
