from jinja2 import Environment, FileSystemLoader
from pynetbox import api

import argparse
import os

NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

DEVICE_NAME = ""
nb = ""

def main():
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('device_name', type=str, help='Name of the device')
    parser.add_argument('template_name', type=str, help='Name of the template file found in ../template')

    args = parser.parse_args()

    global nb
    nb = api(url=NETBOX_URL, token=NETBOX_TOKEN)

    global DEVICE_NAME
    DEVICE_NAME = args.device_name
    file_path = os.path.join('..', 'templates', args.template_name)

    template_str = ""
    if os.path.exists(file_path):
        with open(file_path, 'r') as file:
            template_str = file.read()
    else:
        print(f"The file {file_path} does not exist.")

    template_str = template_str.replace("device.interfaces.filter", "device_interfaces_filter")
    template_str = template_str.replace("Prefix.objects.filter", "prefix_objects_filter")
    template_str = template_str.replace(".all()", "")

    # Netbox needs interface.type, we need interface.type.value
    template_str = template_str.replace(".type", ".type.value")
    template_str = template_str.replace(".mode", ".mode.value")

    loader = FileSystemLoader('../templates/')
    env = Environment(loader=loader, extensions=['jinja2.ext.do'], trim_blocks=True, lstrip_blocks=True)
    env.globals['device_interfaces_filter'] = device_interface_filter
    env.globals['prefix_objects_filter'] = prefixes_filter
    env.globals['device_primary_ip4'] = device_primary_ip(4)
    env.globals['device_primary_ip6'] = device_primary_ip(6)

    template = env.from_string(template_str)

    device = nb.dcim.devices.get(name=DEVICE_NAME)
    config = nb.extras.config_contexts.get(id=1).data
    config["device"] = device

    print(template.render(config))


def device_interface_filter(**kwargs):
    device = nb.dcim.devices.get(name=DEVICE_NAME)
    if not device:
        exit(f"Could not find device with name {DEVICE_NAME}")
    ifs = list(nb.dcim.interfaces.filter(device_id=device.id, **kwargs))
    return ifs


def prefixes_filter(**kwargs):
    prefixes = list(nb.ipam.prefixes.filter(**kwargs))
    if len(prefixes) < 0:
        exit(f"Could not find a prefix for filter {kwargs}")
    if len(prefixes) > 1:
        exit(f"Found too many prefixes for filter {kwargs}")

    return prefixes[0]


def device_primary_ip(version):
    if version == 4:
        ip = nb.dcim.devices.get(name=DEVICE_NAME).primary_ip4
    if version == 6:
        ip = nb.dcim.devices.get(name=DEVICE_NAME).primary_ip6
    return ip


if __name__ == '__main__':
    main()
