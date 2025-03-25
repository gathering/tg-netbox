resource "netbox_config_context" "global_context" {
  name        = "global-context"
  description = "Default config context for TG25"
  sites       = [netbox_site.the_ship.id]
  data = jsonencode(
    {
      SNMP = {
        community = "SkulleBruktTelemetri"
        contact   = "Svettefesten i glassburet"
        location  = "LEGGETIIID!"
      },
      domainName = "tg25.tg.no",
      hashes = {
        handle_api  = "FISK"
        handle_root = "asdasdasd"
        handle_tech = "snurrekanel"
        tacacs      = "kanelsnurrr"
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
        "12.34.56.78",
        "20aa::1"
      ]
      tacacsServers = [
        "21.43.65.87",
        "2000:9999::1"
      ]
    }
  )
}