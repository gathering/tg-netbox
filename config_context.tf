resource "netbox_config_context" "global_context" {
  name        = "global-context"
  description = "Default config context for TG25"
  sites       = [netbox_site.the_ship.id]
  data = jsonencode(
    {
      SNMP = {
        community = "<removed>"
        contact   = "Svettefesten i glassburet"
        location  = "LEGGETIIID!"
      },
      domainName = "tg25.tg.no",
      hashes = {
        handle_api  = "<removed>"
        handle_root = "<removed>"
        handle_tech = "<removed>"
        tacacs      = "<removed>"
      },
      nameServers = [
        "1.1.1.1",
        "8.8.8.8",
        "2001:4860:4860::8888",
        "2001:4860:4860::8844"
      ]
      ntpServers = [
        "129.240.2.6",
        "129.240.2.42",
        "2001:700:100:425::42",
        "2001:700:100:2::6"
      ]
      oxidizedServers = [
        "<removed>",
      ]
      tacacsServers = [
        "<removed>",
      ]
    }
  )
}