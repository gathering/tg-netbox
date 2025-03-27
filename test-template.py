from pickletools import decimalnl_long, decimalnl_short

from jinja2 import Environment, FileSystemLoader, BaseLoader
from pynetbox import api

import argparse
import os

NETBOX_TOKEN = os.getenv("NETBOX_API_TOKEN")
NETBOX_URL = os.getenv("NETBOX_SERVER_URL")

DEVICE_NAME = ""
nb = ""
debug = True

class PreprocessedEnvironment(Environment):
    def get_template(self, name, parent=None, globals=None):
        template_source = self.loader.get_source(self, name)[0]
        preprocessed_source = preprocess_template(template_source)
        return self.from_string(preprocessed_source, globals)


def preprocess_template(template_str):
    replacements = {
        'device.interfaces.filter': 'device_interfaces_filter',
        'ipam.Prefix.objects.filter': 'ipam_prefix_objects_filter',
        'dcim.Device.objects.filter': 'dcim_device_objects_filter',
        'dcim.Interfaces.objects.filter': 'dcim_interfaces_objects_filter',
        'interface.ip_addresses.all()': 'interface_ip_addresses_filter(interface_id=interface.id)',
        '.all()': '',
        '.type': '.type.value',
        '.family': '.family.value',
        '.mode': '.mode.value'
    }

    for search, replace in replacements.items():
        template_str = template_str.replace(search, replace)

    return template_str

def main():
    parser = argparse.ArgumentParser(description='Process some integers.')
    parser.add_argument('device_name', type=str, help='Name of the device')
    parser.add_argument('template_name', type=str, help='Name of the template file found in ../template')

    args = parser.parse_args()

    global nb
    nb = api(url=NETBOX_URL, token=NETBOX_TOKEN)

    global DEVICE_NAME
    DEVICE_NAME = args.device_name
    template_file_path = os.path.join('templates', args.template_name)

    if not os.path.exists(template_file_path):
        print(f"The file {template_file_path} does not exist.")

    loader = FileSystemLoader('.')
    env = PreprocessedEnvironment(loader=loader, extensions=['jinja2.ext.do'], trim_blocks=True, lstrip_blocks=True)
    env.globals['device_interfaces_filter'] = device_interfaces_filter
    env.globals['ipam_prefix_objects_filter'] = ipam_prefixes_filter
    env.globals['dcim_device_objects_filter'] = dcim_device_objects_filter
    env.globals['dcim_interfaces_objects_filter'] = dcim_interfaces_objects_filter
    env.globals['device_primary_ip4'] = device_primary_ip(4)
    env.globals['device_primary_ip6'] = device_primary_ip(6)
    env.globals['interface_ip_addresses_filter'] = interface_ip_addresses_all

    template = env.get_template(template_file_path)

    device = nb.dcim.devices.get(name=DEVICE_NAME)
    config = nb.extras.config_contexts.get(id=1).data
    config["device"] = device

    print(template.render(config))

def interface_ip_addresses_all(**kwargs):
    if debug:
        print(f"interface_ip_addresses_all: {kwargs}")
    device = nb.dcim.devices.get(name=DEVICE_NAME)
    if not device:
        exit(f"Could not find device with name {DEVICE_NAME}")

    addr = list(nb.ipam.ip_addresses.filter(**kwargs))
    return addr

def device_interfaces_filter(**kwargs):
    if debug:
        print(f"device_interfaces_filter: {kwargs}")
    device = nb.dcim.devices.get(name=DEVICE_NAME)
    if not device:
        exit(f"Could not find device with name {DEVICE_NAME}")
    ifs = list(nb.dcim.interfaces.filter(device_id=device.id, **kwargs))
    return ifs

def ipam_prefixes_filter(**kwargs):
    if debug:
        print(f"ipam_prefixes_filter: {kwargs}")
    prefixes = list(nb.ipam.prefixes.filter(**kwargs))
    if len(prefixes) < 0:
        exit(f"Could not find a prefix for filter {kwargs}")
    if len(prefixes) > 1:
        exit(f"Found too many prefixes for filter {kwargs}")

    return prefixes[0]

def dcim_device_objects_filter(**kwargs):
    if debug:
        print(f"dcim_device_objects_filter: {kwargs}")
    devices = list(nb.dcim.devices.filter(**kwargs))
    return devices

def dcim_interfaces_objects_filter(**kwargs):
    if debug:
        print(f"dcim_interfaces_objects_filter: {kwargs}")
    ifs = list(nb.dcim.interfaces.filter(**kwargs))
    return ifs

def device_primary_ip(version):
    if version == 4:
        ip = nb.dcim.devices.get(name=DEVICE_NAME).primary_ip4
    if version == 6:
        ip = nb.dcim.devices.get(name=DEVICE_NAME).primary_ip6
    return ip


if __name__ == '__main__':
    main()
