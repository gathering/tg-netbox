import json

from extras.scripts import *
from django.contrib.contenttypes.models import ContentType

from dcim.models import Cable, CableTermination, Device, DeviceType, Location, DeviceRole, Site, Interface, \
    VirtualChassis
from dcim.choices import InterfaceModeChoices, InterfaceTypeChoices

from ipam.models import VLANGroup, VLAN, Role, Prefix, IPAddress, VRF
from ipam.choices import PrefixStatusChoices

from extras.models import ConfigTemplate

import random
import string

from utilities.exceptions import AbortScript

## Features
# ✅ Edge switch on Ringen
# ✅ Edge on "utskutt distro"
# ✅ Edge switch on distro leaf
# ✅ Edge switch on leaf-pair
# ✅ Utskutt distro (nice to have)

DEFAULT_SWITCH_NAME = "e1-changemyname"
DEFAULT_SITE = Site.objects.get(name='Vikingskipet')
DEFAULT_DEVICE_TYPE = DeviceType.objects.get(model='EX2200-48T-4G')
DEFAULT_DEVICE_ROLE = DeviceRole.objects.get(slug='access-switch')
DEFAULT_TG_DNS_SUFFIX = "tg25.tg.no"
DEFAULT_UPLINK_SWITCH = Device.objects.get(name='d1-ring-noc')

DEVICE_ROLE_ACCESS = "access-switch"
DEVICE_ROLE_DISTRO = "distro"
DEVICE_ROLE_LEAF = "leaf"
DEVICE_ROLE_UTSKUTT_DISTRO = "utskutt-distro"

# VLAN Group to allocate VLANs from
FABRIC_VLAN_GROUP = VLANGroup.objects.get(slug='client-vlans')

# Vlan role for fabric clients
FABRIC_CLIENTS_ROLE = Role.objects.get(slug='clients')

# VRF for fabric clients
FABRIC_CLIENTS_VRF = VRF.objects.get(name='CLIENTS')

# VRF for internet clients on the fabric
FABRIC_INET_VRF = VRF.objects.get(name='INET')

# Client networks allocated from here
FABRIC_V4_CLIENTS_PREFIX = Prefix.objects.get(prefix__family=4, prefix='10.25.0.0/16', vrf=FABRIC_CLIENTS_VRF)
FABRIC_V6_CLIENTS_PREFIX = Prefix.objects.get(prefix__family=6, prefix='2a06:5844:e::/48', vrf=FABRIC_CLIENTS_VRF)

# Switch mgmt allocates from here
FABRIC_V4_JUNIPER_MGMT_PREFIX = Prefix.objects.get(prefix__family=4, prefix='185.110.149.0/25', vrf=FABRIC_CLIENTS_VRF)
FABRIC_V6_JUNIPER_MGMT_PREFIX = Prefix.objects.get(prefix__family=6, prefix='2a06:5841:f::/64', vrf=FABRIC_CLIENTS_VRF)

UPLINK_PORTS = {
    'EX2200-48T-4G': ["ge-0/0/44", "ge-0/0/45", "ge-0/0/46", "ge-0/0/47"],
    'EX3300-48P': ["xe-0/1/0", "xe-0/1/1"],  # xe-0/1/2 and xe-0/1/3 can be used for clients
}

IRB_MODELS = ["EX2200-48T-4G", "EX3300-48P"]

UPLINK_TYPES = (
    (InterfaceTypeChoices.TYPE_10GE_FIXED, '10G RJ45'),
    (InterfaceTypeChoices.TYPE_10GE_SFP_PLUS, '10G SFP+'),
    (InterfaceTypeChoices.TYPE_25GE_SFP28, '25G SFP28'),
    (InterfaceTypeChoices.TYPE_1GE_FIXED, '1G RJ45'),
    (InterfaceTypeChoices.TYPE_2GE_FIXED, '2.5G RJ45')
)

UPLINK_SUPPORT_MATRIX = {
    InterfaceTypeChoices.TYPE_25GE_SFP28: [InterfaceTypeChoices.TYPE_10GE_SFP_PLUS,
                                           InterfaceTypeChoices.TYPE_25GE_SFP28],
    InterfaceTypeChoices.TYPE_10GE_SFP_PLUS: [InterfaceTypeChoices.TYPE_10GE_SFP_PLUS,
                                              InterfaceTypeChoices.TYPE_25GE_SFP28],
    InterfaceTypeChoices.TYPE_2GE_FIXED: [InterfaceTypeChoices.TYPE_2GE_FIXED, InterfaceTypeChoices.TYPE_1GE_FIXED],
    InterfaceTypeChoices.TYPE_1GE_FIXED: [InterfaceTypeChoices.TYPE_2GE_FIXED, InterfaceTypeChoices.TYPE_1GE_FIXED]
}


def generatePrefix(prefix, length):
    firstPrefix = prefix.get_first_available_prefix()
    if firstPrefix is None:
        print(f"No prefixes available in {prefix}")
    out = list(firstPrefix.subnet(length, count=1))[0]
    return out


class CreateSwitch(Script):
    class Meta:
        name = "Create Switch"
        description = "Provision a new switch"
        commit_default = True
        fieldsets = ""
        scheduling_enabled = False

    switch_name = StringVar(
        description="Switch name. Remember, e = access switch, d = distro switch. Regex: '^[ed]\d{1,2}\-'",
        required=True,
        default=DEFAULT_SWITCH_NAME,
        regex="^[ed]\d{1,2}\-"
    )
    device_type = ObjectVar(
        description="Device model",
        model=DeviceType,
        default=DEFAULT_DEVICE_TYPE.id,
    )
    device_role = ObjectVar(
        description="Device role",
        model=DeviceRole,
        default=DEFAULT_DEVICE_ROLE.id,
    )
    uplink_type = MultiChoiceVar(
        label='Uplink Type',
        required=True,
        description="What type of interface should this switch be delivered on",
        choices=UPLINK_TYPES,
        default=InterfaceTypeChoices.TYPE_1GE_FIXED
    )
    destination_device_a = ObjectVar(
        description="Uplink device (A)",
        required=True,
        model=Device,
        query_params={
            'role': [DEVICE_ROLE_LEAF, DEVICE_ROLE_DISTRO, DEVICE_ROLE_UTSKUTT_DISTRO],
        },
        default=DEFAULT_UPLINK_SWITCH
    )
    destination_device_b = ObjectVar(
        description="If connected to leaf pair - Uplink device (B)",
        required=False,
        model=Device,
        query_params={
            'role': [DEVICE_ROLE_LEAF],
        },
    )
    # If leaf pair we assume same port. This input only cares about cases with single device.
    destination_interfaces = MultiObjectVar(
        description="Destination interface(s)",
        model=Interface,
        query_params={
            'device_id': '$destination_device_a',
            'occupied': False,
            'type': '$uplink_type'
        }
    )

    def run(self, data, commit):

        switch_name = data['switch_name']
        device_type = data['device_type']
        device_role = data['device_role']
        uplink_type = data['uplink_type']
        destination_device_a = data['destination_device_a']
        destination_device_b = data['destination_device_b']
        destination_interfaces = data['destination_interfaces']

        # workaround for Netbox discussion #18229 - if str we assume script is called from the API
        if type(data['device_type']).__name__ == "str":
            device_type = DeviceType.objects.get(model=data['device_type'])
            device_role = DeviceRole.objects.get(name=data['device_role'])
            uplink_type = [InterfaceTypeChoices.TYPE_1GE_FIXED]
            destination_device_a = Device.objects.get(name=data['destination_device_a'])
            if not data['destination_device_b'] == "":
                destination_device_b = Device.objects.get(name=data['destination_device_b'])

            ifs = data['destination_interfaces'].split(",")
            destination_interfaces = Interface.objects.filter(device_id=destination_device_a.id, name__in=ifs)

        self.log_debug("")
        switch = self.create_switch(switch_name, device_type, device_role, destination_device_a)

        # These only exists if we are provisioning an access switch
        vlan = None
        v6_prefix = None
        v4_prefix = None

        if switch.role.slug == DEVICE_ROLE_ACCESS:
            vlan = self.create_vlan(switch)
            v4_prefix, v6_prefix = self.allocate_prefixes(vlan)
            self.set_traffic_vlan(switch, vlan)

        self.connect_switch(switch, uplink_type, destination_device_a, destination_device_b, destination_interfaces,
                            vlan)
        self.log_success(f"✅ Script completed successfully.")
        self.log_success(f"🔗 Switch:     <a href=\"{switch.get_absolute_url()}\">{switch}</a>")

        if switch.role.slug == DEVICE_ROLE_ACCESS:
            self.log_success(f"🔗 v6 Prefix:  <a href=\"{v6_prefix.get_absolute_url()}\">{v6_prefix}</a>")
            self.log_success(f"🔗 v4 Prefix:  <a href=\"{v4_prefix.get_absolute_url()}\">{v4_prefix}</a>")
            self.log_success(f"🔗 VLAN:       <a href=\"{vlan.get_absolute_url()}\">{vlan}</a>")
        self.log_success(f"⚠️ <strong>️Fabric config must be deployed before switch can be fapped.</strong>")
        return json.dumps(
            {
                "switch_name": switch.name,
                "switch_url": switch.get_absolute_url(),
                "network_v4": str(v4_prefix.prefix) if v4_prefix is not None else None,
                "network_v6": str(v4_prefix.prefix) if v6_prefix is not None else None,
                "switch_mgmt_v4": str(switch.primary_ip4.address),
                "switch_mgmt_v6": str(switch.primary_ip6.address)
            }
        )

    def allocate_prefixes(self, vlan):
        v6_prefix = Prefix.objects.create(
            prefix=generatePrefix(FABRIC_V6_CLIENTS_PREFIX, 64),
            status=PrefixStatusChoices.STATUS_ACTIVE,
            role=FABRIC_CLIENTS_ROLE,
            vrf=FABRIC_CLIENTS_VRF,
            vlan=vlan
        )
        v4_prefix = Prefix.objects.create(
            prefix=generatePrefix(FABRIC_V4_CLIENTS_PREFIX, 26),
            status=PrefixStatusChoices.STATUS_ACTIVE,
            role=FABRIC_CLIENTS_ROLE,
            vrf=FABRIC_CLIENTS_VRF,
            vlan=vlan
        )
        self.log_info("Created network. Created new VLAN and assigned prefixes")
        return v4_prefix, v6_prefix

    def connect_switch(self, switch, uplink_types, uplink_device_a, uplink_device_b, destination_interfaces, vlan=None):
        uplink_lag_name = self.get_next_free_lag_number(uplink_device_a)

        switch_uplink_description = f"B: {uplink_device_a} {uplink_lag_name}"
        if uplink_device_b:
            switch_uplink_description = f"B: {uplink_device_a.name} / {uplink_device_a.name} {uplink_lag_name}"

        switch_uplink_lag = Interface.objects.create(
            device=switch,
            name="ae0",
            description=switch_uplink_description,
            type=InterfaceTypeChoices.TYPE_LAG,
            mode=InterfaceModeChoices.MODE_TAGGED,
            untagged_vlan=FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan,
        )
        switch_uplink_lag.save()
        
        switch_uplink_lag.tagged_vlans.add(FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan.id)

        ae_device = uplink_device_a
        if uplink_device_a.virtual_chassis:
            ae_device = uplink_device_a.virtual_chassis.master

        if switch.role.slug == DEVICE_ROLE_ACCESS:
            ## Add vlan upstream if not connected to leaf
            if uplink_device_a.role.slug != DEVICE_ROLE_LEAF:
                lag_on_uplink_device = Interface.objects.get(device=ae_device, name="ae0")
                lag_on_uplink_device.tagged_vlans.add(vlan.id)

            ## if utskutt distro, add even more upstream
            if uplink_device_a.role.slug == DEVICE_ROLE_UTSKUTT_DISTRO:
                ring_fabric_uplink = Interface.objects.get(device__name="d1-ring-noc", name="ae0")
                ring_fabric_uplink.tagged_vlans.add(vlan.id)

            switch_uplink_lag.tagged_vlans.add(vlan.id)

        possible_uplink_types = []
        self.log_debug(f"uplink types {uplink_types}")
        for type in uplink_types:
            self.log_debug(f"for type {type} - adding {UPLINK_SUPPORT_MATRIX.get(type, [])} to possible uplinks")
            possible_uplink_types.append(UPLINK_SUPPORT_MATRIX.get(type, []))

        # flatten list
        possible_uplink_types = [x for xs in possible_uplink_types for x in xs]
        self.log_debug(f"possible types {possible_uplink_types}")

        uplink_interfaces = list(Interface.objects.filter(device_id=switch.id, type__in=possible_uplink_types))
        if len(uplink_interfaces) < 1:
            raise AbortScript(
                f"You chose a device type without any {possible_uplink_types} interfaces! Pick another model :)")

        netbox_interface_type = ContentType.objects.get_for_model(Interface)
        uplink_ports = [interface for interface in uplink_interfaces if
                        interface.name in UPLINK_PORTS.get(switch.device_type.model, [])]

        if len(uplink_ports) < 1:
            raise AbortScript(f"No uplink ports defined for {switch.device_type.model}")

        ## Only create LAG on uplink device if not leaf-pair (no mlag support out of the box in Netbox)
        if not uplink_device_b:
            uplink_device_lag = self.create_uplink_lag(switch, uplink_device_a, uplink_lag_name, vlan)

        num_uplinks = len(destination_interfaces)
        if uplink_device_b:
            num_uplinks = 2  # If connected to a leaf-pair, num uplinks are two

        for uplink_num in range(0, num_uplinks):
            switch_uplink_interface = uplink_ports[uplink_num]

            uplink_device = uplink_device_a
            if uplink_device_b and uplink_num == 1:
                uplink_device = uplink_device_b

            if uplink_device_b and uplink_num == 1:
                uplink_ifname = destination_interfaces[0].name
                uplink_device_interface = Interface.objects.get(device=uplink_device_b, name=uplink_ifname)
            else:
                uplink_device_interface = destination_interfaces[uplink_num]

            uplink_device_interface.description = f'G: {switch.name} {switch_uplink_interface.name} ({uplink_lag_name})'
            uplink_device_interface.save()
            if uplink_num == 0:
                uplink_device_interface.tags.add("fap-interface")

            switch_uplink_interface.description = f"G: {uplink_device_a.name} {uplink_device_interface.name} (ae0)"
            switch_uplink_interface.lag = switch_uplink_lag
            switch_uplink_interface.save()

            ## Only create LAG on uplink device if not leaf-pair (no mlag support out of the box in Netbox)
            if not uplink_device_b:
                uplink_device_interface.lag = uplink_device_lag
                uplink_device_interface.save()

            cable = Cable.objects.create()
            a = CableTermination.objects.create(
                cable=cable,
                cable_end='A',
                termination_id=uplink_device_interface.id,
                termination_type=netbox_interface_type,
            )
            b = CableTermination.objects.create(
                cable_end='B',
                cable=cable,
                termination_id=switch_uplink_interface.id,
                termination_type=netbox_interface_type,
            )
            cable = Cable.objects.get(id=cable.id)
            # https://github.com/netbox-community/netbox/discussions/10199
            cable._terminations_modified = True
            cable.save()
            self.log_debug(
                f"Connected: {uplink_device} - {uplink_device_interface} to {switch} - {switch_uplink_interface}")

    def get_next_free_lag_number(self, uplink_device_a):
        interfaces = []
        if uplink_device_a.virtual_chassis != None:
            vc = VirtualChassis.objects.get(id=uplink_device_a.virtual_chassis.id)
            self.log_debug(f"vc {vc}")
            for member in vc.members.all():
                interfaces = interfaces + list(Interface.objects.filter(device=member, type=InterfaceTypeChoices.TYPE_LAG))
        else:
            interfaces = list(Interface.objects.filter(device=uplink_device_a, type=InterfaceTypeChoices.TYPE_LAG))

        existing_lag_names = [x.name for x in interfaces]
        lag_prefix = "ae"
        if uplink_device_a.device_type.manufacturer.name == "Arista":
            lag_prefix = "Po"

        self.log_debug(f"existing lag names: {existing_lag_names}")
        if "ae10" not in existing_lag_names and "Po10" not in existing_lag_names:
            return f"{lag_prefix}10"

        lag_numbers = [int(lag[2:]) for lag in existing_lag_names]
        next_free = max(lag_numbers) + 1
        return f"{lag_prefix}{next_free}"

    def create_switch(self, switch_name, device_type, device_role, destination_device_a):
        if switch_name == DEFAULT_SWITCH_NAME:
            switch_name = f"e1.test-{''.join(random.sample(string.ascii_uppercase * 6, 6))}"

        config_template = ConfigTemplate.objects.get(name="juniper")

        switch = Device(
            name=switch_name,
            device_type=device_type,
            location=destination_device_a.location,
            role=device_role,
            site=DEFAULT_SITE,
            config_template=config_template,
        )
        switch.save()

        mgmt_interface_name = "irb"
        if switch.device_type.model in IRB_MODELS:
            mgmt_interface_name = "vlan"

        mgmt_vlan_interface = Interface.objects.create(
            device=switch,
            name=f"{mgmt_interface_name}.{FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan.vid}",
            description=f'X: Mgmt',
            type=InterfaceTypeChoices.TYPE_VIRTUAL,
            mode=InterfaceModeChoices.MODE_ACCESS,
            untagged_vlan=FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan,
        )
        v4_mgmt_addr = IPAddress.objects.create(
            address=FABRIC_V4_JUNIPER_MGMT_PREFIX.get_first_available_ip(),
            vrf=FABRIC_V4_JUNIPER_MGMT_PREFIX.vrf,
            dns_name=f"{switch.name}.{DEFAULT_TG_DNS_SUFFIX}"
        )
        v6_mgmt_addr = IPAddress.objects.create(
            address=FABRIC_V6_JUNIPER_MGMT_PREFIX.get_first_available_ip(),
            vrf=FABRIC_V6_JUNIPER_MGMT_PREFIX.vrf,
            dns_name=f"{switch.name}.{DEFAULT_TG_DNS_SUFFIX}"
        )
        mgmt_vlan_interface.ip_addresses.add(v4_mgmt_addr)
        mgmt_vlan_interface.ip_addresses.add(v6_mgmt_addr)
        switch.primary_ip4 = v4_mgmt_addr
        switch.primary_ip6 = v6_mgmt_addr
        switch.save()

        self.log_info("Created switch")
        self.log_info("Allocated and assigned mgmt addresses on switch")
        return switch

    def create_vlan(self, switch):
        vid = FABRIC_VLAN_GROUP.get_next_available_vid()
        vlan = VLAN.objects.create(
            name=switch.name,
            group=FABRIC_VLAN_GROUP,
            role=FABRIC_CLIENTS_ROLE,
            vid=vid
        )
        vlan.save()
        self.log_info("Created VLAN")
        return vlan

    def set_traffic_vlan(self, switch, vlan):
        interfaces = list(Interface.objects.filter(device=switch, type=InterfaceTypeChoices.TYPE_1GE_FIXED))
        if len(interfaces) == 0:
            self.log_error(f"no interfaces found")

        for interface in interfaces:
            if interface.name in UPLINK_PORTS.get(switch.device_type.model, []):
                continue
            interface.mode = 'access'
            interface.untagged_vlan = vlan
            interface.description = "C: Clients"
            interface.save()
        self.log_info("Configured traffic vlan on all client ports")

    def create_uplink_lag(self, switch, uplink_device_a, uplink_lag_name, vlan=None):
        destination_lag = Interface.objects.create(
            device=uplink_device_a,
            name=f"{uplink_lag_name}",
            description=f'B: {switch.name} ae0',
            type=InterfaceTypeChoices.TYPE_LAG,
            mode=InterfaceModeChoices.MODE_TAGGED,
            untagged_vlan=FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan,
        )
        destination_lag.save()
        destination_lag.tagged_vlans.add(FABRIC_V4_JUNIPER_MGMT_PREFIX.vlan.id)
        if switch.role.slug == DEVICE_ROLE_ACCESS:
            destination_lag.tagged_vlans.add(vlan.id)
        self.log_debug(
            f"Created destination LAG <a href=\"{destination_lag.get_absolute_url()}\">{destination_lag}</a>")
        return destination_lag


script = CreateSwitch