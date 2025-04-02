locals {
  dcim_roles = [
    { name = "Access switch", color_hex = "ff5722" },
    { name = "Distro", color_hex = "ff9800" },
    { name = "Firewall", color_hex = "ffe4e1" },
    { name = "Generic", color_hex = "e91e63" },
    { name = "Hypervisor", color_hex = "4caf50" },
    { name = "Internett ruter", color_hex = "673ab7" },
    { name = "Leaf", color_hex = "2196f3" },
    { name = "OOB Switch", color_hex = "9e9e9e" },
    { name = "Patch Panel", color_hex = "ffffff" },
    { name = "Spine", color_hex = "aa1409" },
    { name = "Utskutt distro", color_hex = "9c27b0" },
  ]
}

resource "netbox_site" "the_ship" {
  name    = "Vikingskipet"
  asn_ids = [for asn in netbox_asn.asns : asn.id]
}

resource "netbox_device_role" "roles" {
  for_each  = { for role in local.dcim_roles : replace(lower(role.name), " ", "-") => role }
  name      = each.value.name
  color_hex = each.value.color_hex
  slug      = each.key
  vm_role   = lookup(each.value, "vm_role", false)
}
