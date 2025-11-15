import pynetbox
import os


NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

nb = pynetbox.api(NETBOX_URL, token=NETBOX_TOKEN)

interfaces = nb.dcim.interfaces.all()

legacy_wifi_vlan = nb.ipam.vlans.get(name="wifi-tg-legacy")
if not legacy_wifi_vlan:
    exit("legacy wifi not found")

for interface in interfaces:
    if len(interface.tagged_vlans) > 0 and "wifi-thegathering" in [x.name for x in interface.tagged_vlans]:
        print(interface)
        vlans = interface.tagged_vlans
        vlans.append(legacy_wifi_vlan)
        interface.update({"tagged_vlans": vlans})

        print(f"added legacy wifi vlan to interface {interface.id}")
        exit(1)
        break
