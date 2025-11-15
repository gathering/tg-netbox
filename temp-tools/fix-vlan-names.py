import pynetbox
import os

NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

nb = pynetbox.api(NETBOX_URL, token=NETBOX_TOKEN)

# Fetch all VLANs
vlans = nb.ipam.vlans.all()

for vlan in vlans:
    if '.' in vlan.name:
        new_name = vlan.name.replace('.', '-')
        print(f"Updating VLAN {vlan.vid}: '{vlan.name}' → '{new_name}'")
        vlan.update({'name': new_name})
