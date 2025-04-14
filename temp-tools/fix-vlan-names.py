import pynetbox

# Connect to NetBox
NETBOX_URL = "https://netbox.tg25.tg.no"
NETBOX_TOKEN = "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa"

nb = pynetbox.api(NETBOX_URL, token=NETBOX_TOKEN)

# Fetch all VLANs
vlans = nb.ipam.vlans.all()

for vlan in vlans:
    if '.' in vlan.name:
        new_name = vlan.name.replace('.', '-')
        print(f"Updating VLAN {vlan.vid}: '{vlan.name}' → '{new_name}'")
        vlan.update({'name': new_name})
