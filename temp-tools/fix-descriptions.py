import pynetbox
import re
import os

NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

nb = pynetbox.api(NETBOX_URL, token=NETBOX_TOKEN)

interfaces = nb.dcim.interfaces.all()
for interface in interfaces:
    if '.' in interface.description:
        match = re.search(r'([a-z]{1}[0-9]{1})\.([a-z-]{1,})', interface.description)
        if match:
            new_device_name = match.group(1) + '-' + match.group(2)
            new_description = interface.description.replace(match.group(0), new_device_name)
            print(f'{interface.description} -> {new_description}')
            interface.update({'description': new_description})