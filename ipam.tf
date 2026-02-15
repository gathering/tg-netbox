resource "netbox_rir" "tg25" {
  name       = "TG25 Private"
  is_private = true
}

resource "netbox_rir" "kandu" {
  name       = "KANDU"
  is_private = false
}

resource "netbox_rir" "telenor" {
  name       = "Telenor"
  is_private = false
}

locals {
  ipam_roles = [
    { name = "Clients" },
    { name = "Juniper mgmt" },
    { name = "Infrastruktur" },
    { name = "Linknet" },
    { name = "Loopback" },
    { name = "Servers" },
  ]
  as_nubmers = [
    { asn = 21067, rir = netbox_rir.kandu, description = "KANDU" },
    { asn = 65100, rir = netbox_rir.tg25, description = "FABRIC BASE" },
    { asn = 65200, rir = netbox_rir.tg25, description = "FW" },
    { asn = 65210, rir = netbox_rir.tg25, description = "INET VRF" },
    { asn = 65211, rir = netbox_rir.tg25, description = "CLIENTS VRF" },
  ]
  aggregates = [
    { prefix = "10.0.0.0/8", description = "RFC1918", rir = netbox_rir.tg25 },
    { prefix = "88.92.0.0/18", description = "Telenor", rir = netbox_rir.telenor },
    { prefix = "185.110.148.0/22", description = "KANDU v4", rir = netbox_rir.kandu },
    { prefix = "2a06:5840::/29", description = "KANDU v6", rir = netbox_rir.kandu },
    { prefix = "193.212.22.0/30", description = "Telenor v4 linknet", rir = netbox_rir.telenor },
    { prefix = "2001:4600:9:300::290/126", description = "Telenor v6 linknet", rir = netbox_rir.telenor },
  ]
  vrfs = [
    { name = "default", description = "For underlay i fabricen" },
    { name = "CLIENTS", description = "Nett som lever i fabricen (v4 NAT)" },
    { name = "INET", description = "Nett som lever i fabricen - ingen v4 NAT" },
    { name = "MGMT", description = "Arista Management, Terminert på Internett ruter" },
  ]
  prefixes = [
    { description = "RFC1918", prefix = "10.0.0.0/8", status = "container", role_id = null },
    { description = "KANDU v4", prefix = "185.110.148.0/22", status = "container", role_id = null },
    { description = "KANDU v6", prefix = "2a06:5840::/29", status = "container", role_id = null },
    { description = "Infra konteiner v4", prefix = "185.110.148.0/24", status = "container", role_id = netbox_ipam_role.roles["Infrastruktur"].id },
    { description = "Infra konteiner v6", prefix = "2a06:5841:f::/48", status = "container", role_id = netbox_ipam_role.roles["Infrastruktur"].id },
    { description = "Linknets v4", prefix = "185.110.148.0/27", status = "container", role_id = netbox_ipam_role.roles["Linknet"].id },
    { description = "Linknets v6", prefix = "2a06:5841:f:100::/56", status = "container", role_id = netbox_ipam_role.roles["Linknet"].id },
    { description = "Loopbacks v4", prefix = "185.110.148.32/27", status = "container", role_id = netbox_ipam_role.roles["Loopback"].id },
    { description = "Loopbacks v6", prefix = "2a06:5841:f:200::/64", status = "container", role_id = netbox_ipam_role.roles["Loopback"].id },
    { description = "Juniper mgmt v4", prefix = "185.110.149.0/24", status = "active", role_id = netbox_ipam_role.roles["Infrastruktur"].id, vrf_id = netbox_vrf.vrfs["CLIENTS"].id },
    { description = "Juniper mgmt v6", prefix = "2a06:5841:f::/64", status = "active", role_id = netbox_ipam_role.roles["Infrastruktur"].id, vrf_id = netbox_vrf.vrfs["CLIENTS"].id },
  ]
}

resource "netbox_ipam_role" "roles" {
  for_each = { for role in local.ipam_roles : tostring(role.name) => role }
  name     = each.value.name
}

resource "netbox_asn" "asns" {
  for_each    = { for asn in local.as_nubmers : tostring(asn.asn) => asn }
  asn         = each.key
  description = each.value.description
  rir_id      = each.value.rir.id
}

resource "netbox_aggregate" "aggregates" {
  for_each = { for agg in local.aggregates : tostring(agg.description) => agg }

  prefix      = each.value.prefix
  description = each.value.description
  rir_id      = each.value.rir.id
}

resource "netbox_vrf" "vrfs" {
  for_each    = { for vrf in local.vrfs : tostring(vrf.name) => vrf }
  name        = each.value.name
  description = each.value.description
}

resource "netbox_prefix" "prefixes" {
  for_each = { for prefix in local.prefixes : tostring(prefix.prefix) => prefix }

  prefix      = each.value.prefix
  status      = each.value.status
  description = each.value.description
  role_id     = each.value.role_id
  vrf_id      = try(each.value.vrf_id, null)
}

resource "netbox_vlan_group" "Client VLANs" {
  name    = "Client VLANs"
  slug    = "client-vlans"
  vid_ranges = ["200-4096"]
}