resource "netbox_rir" "tg25" {
  name       = "TG25"
  is_private = true
}

resource "netbox_asn" "fabric" {
  asn         = 65100
  description = "FABRIC BASE"
  rir_id      = netbox_rir.tg25.id
}

resource "netbox_asn" "fw" {
  asn         = 65200
  description = "FW"
  rir_id      = netbox_rir.tg25.id
}

resource "netbox_asn" "inet" {
  asn         = 65210
  description = "INET VRF"
  rir_id      = netbox_rir.tg25.id
}

resource "netbox_asn" "clients" {
  asn         = 65211
  description = "CLIENTS VRF"
  rir_id      = netbox_rir.tg25.id
}

resource "netbox_site" "the_ship" {
  name    = "Vikingskipet"
  asn_ids = [netbox_asn.clients.id, netbox_asn.fabric.id, netbox_asn.fw.id, netbox_asn.inet.id]
}

