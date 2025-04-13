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
        handle_api  = "$6$o3yH6BPA$kvN3XU9yfDduzrerBuPM2pIC3VzmSobfXuNvVdDNH5/5SHDa1fM5RQDONYeMzgGnFkWldcroYpByBYOoqY6aw."
        handle_root = "$6$17aT/GOm$hjhMYX2QtisYwV/cdhbyolMfutNk.13xcoGAnTyyFOBnTQQxOknBbQKfDqOu10SflelCQIUxpJRCoKsdum3rt0"
        handle_tech = "$6$o3yH6BPA$kvN3XU9yfDduzrerBuPM2pIC3VzmSobfXuNvVdDNH5/5SHDa1fM5RQDONYeMzgGnFkWldcroYpByBYOoqY6aw."
        tacacs      = "$9$qf5Q/9puBRn/WL7NY2369tuBreW-dwEcoGDkPfRhcyv8db2JUHoJi.PfF3hSrv87bs4Ujk.PvWXxdVfTQ36CuOREhyvWmfz3AtWLXNs4DjHm5zLxNdVbg4/CtOhSylM-dsNd2aUHf5puOIEcKvW8X-UjA0BRrlYgoJDk/9tIESB1"
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
        "2a02:d140:c012:1::73",
      ]
      tacacsServers = [
        "2a02:d140:c012:1::73",
      ]
    }
  )
}