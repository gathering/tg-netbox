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
    { name = "AP", slug = "ap", color_hex = "00ff00"}
  ]
  locations = [
    { name = "Floor", site = "Vikingskipet", slug = "floor" },
    { name = "NOC", site = "Vikingskipet", slug = "noc" },
    { name = "Ringen", site = "Vikingskipet", slug = "ringen" },
    { name = "Stand", site = "Vikingskipet", slug = "stand" },
    { name = "Stand-Altibox", site = "Vikingskipet", slug = "stand-altibox" },
    { name = "Tele", site = "Vikingskipet", slug = "tele" },
    { name = "crewburet", site = "Vikingskipet", slug = "crewburet" },
    { name = "log", site = "Vikingskipet", slug = "log" },
    { name = "north", site = "Vikingskipet", slug = "north" },
    { name = "reception", site = "Vikingskipet", slug = "reception" },
    { name = "roof-north", site = "Vikingskipet", slug = "roof-north" },
    { name = "roof-south", site = "Vikingskipet", slug = "roof-south" },
    { name = "south", site = "Vikingskipet", slug = "south" },
    { name = "swing", site = "Vikingskipet", slug = "swing" },
    { name = "vrimle", site = "Vikingskipet", slug = "vrimle" }
  ]
  manufacturers = [
    { name = "Arista" , slug = "arista" },
    { name = "Generic" , slug = "generic" },
    { name = "Juniper" , slug = "juniper" },
    { name = "Palo Alto" , slug = "palo-alto" },
    { name = "Supermicro" , slug = "supermicro" }
  ]
  tags = [
     { name = "sc-sc-patch",slug = "sc-sc-patch",color = "009688",description = "SC to SC patch cable" },
     { name = "lc-lc-patch",slug = "lc-lc-patch",color = "ff5722",description = "LC to LC patch cable" },
     { name = "lc-sc-patch",slug = "lc-sc-patch",color = "00ffff",description = "LC to SC patch cable" },
     { name = "tg-fiber",slug = "tg-fiber",color = "ffeb3b",description = "Permanently installed fiber" }
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

resource "netbox_location" "locations" {
  for_each = { for location in local.locations : location.slug => location }
  name     = each.value.name
  slug     = each.value.slug
  site_id  = netbox_site.the_ship.id
}

resource "netbox_manufacturer" "manufacturers" {
  for_each = { for manufacturer in local.manufacturers : manufacturer.slug => manufacturer }
  name = each.value.name
  slug = each.value.slug
}

resource "netbox_tag" "tags" {
  for_each = { for tag in local.tags : tag.slug => tag }
  name        = each.value.name
  slug        = each.value.slug
  color_hex   = each.value.color
  description = each.value.description
}

resource "netbox_custom_field" "gondul_placement" {
  name           = "gondul_placement"
  type           = "json"
  content_types  = ["dcim.device"]
  weight         = 1000
  default        = jsonencode({
    height: 20,
    width: 140
    x: null,
    y: null,
  })

  group_name     = "Gondul"
  label          = "Gondul Placement"
}
