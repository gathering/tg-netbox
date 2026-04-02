from extras.scripts import *

from dcim.models import Device, DeviceType, Interface
from dcim.choices import InterfaceTypeChoices

from ipam.models import VLANGroup, VLAN, Role, Prefix, VRF
from ipam.choices import PrefixStatusChoices

from utilities.exceptions import AbortScript

UPLINK_TYPES = (
    (InterfaceTypeChoices.TYPE_10GE_FIXED, '10G RJ45'),
    (InterfaceTypeChoices.TYPE_10GE_SFP_PLUS, '10G SFP+'),
    (InterfaceTypeChoices.TYPE_25GE_SFP28, '25G SFP28'),
    (InterfaceTypeChoices.TYPE_1GE_FIXED, '1G RJ45'),
    (InterfaceTypeChoices.TYPE_2GE_FIXED, '2.5G RJ45'),
    (InterfaceTypeChoices.TYPE_5GE_FIXED, '5G RJ45')
)

# Device role slug for leaf and l2-leaf switches
DEVICE_ROLE_LEAF = "leaf"
DEVICE_ROLE_L2LEAF = "l2-leaf"

# !! !! !! These objects have to exist in Netbox for the script to work !! !! !!
# Creating these as lambdas to not crash on script load if the objects do not exist.

# VLAN Group to allocate VLANs from
FABRIC_LEAF_VLAN_GROUP = lambda: VLANGroup.objects.get(slug='leaf-clients')

# Vlan role for fabric clients
FABRIC_CLIENTS_ROLE = lambda: Role.objects.get(slug='clients')

# VRF for fabric clients
FABRIC_CLIENTS_VRF = lambda: VRF.objects.get(name='CLIENTS')

# Client networks allocated from here
FABRIC_V4_LEAF_CLIENTS_PREFIX = lambda: Prefix.objects.get(prefix__family=4, prefix='10.25.128.0/20', vrf=FABRIC_CLIENTS_VRF())
FABRIC_V6_LEAF_CLIENTS_PREFIX = lambda: Prefix.objects.get(prefix__family=6, prefix='2a06:5844:e:a000::/52', vrf=FABRIC_CLIENTS_VRF())

# Don't default if the defaults don't exist
try:
    DEFAULT_SWITCH_NAME = Device.objects.get(name='d1-noc')
except:
    DEFAULT_SWITCH_NAME = None

def generatePrefix(prefix, length):
    firstPrefix = prefix.get_first_available_prefix()
    out = list(firstPrefix.subnet(length, count=1))[0]
    return out

class CreateLeafAccess(Script):
    class Meta:
        name = "Create Access ports on Arista Leaf Switch"
        description = "Create new access vlan and add to ports on Arista leaf switch"
        commit_default = True
        fieldsets = ""
        scheduling_enabled = False

    switch_name = ObjectVar(
        description="Leaf Switch",
        model=Device,
        query_params={
            'role': [DEVICE_ROLE_LEAF, DEVICE_ROLE_L2LEAF],
        },
        required=True,
        default=DEFAULT_SWITCH_NAME,
    )

    uplink_type = MultiChoiceVar(
        label='Uplink Type',
        required=True,
        description="What type of interface should be configured to access port",
        choices=UPLINK_TYPES,
        default=[InterfaceTypeChoices.TYPE_1GE_FIXED, InterfaceTypeChoices.TYPE_2GE_FIXED, InterfaceTypeChoices.TYPE_5GE_FIXED]
    )

    interfaces = MultiObjectVar(
        description="Interface(s)",
        model=Interface,
        query_params={
            'device_id': '$switch_name',
            'occupied': False,
            'type': '$uplink_type'
        }
    )

    def run(self, data, commit):
        self.run_tests()

        switch_name = data['switch_name']
        interfaces = data['interfaces']

        self.log_debug("")

        vlan = None
        v6_prefix = None
        v4_prefix = None

        vlan, vlan_is_new = self.create_vlan(switch_name)
        if vlan_is_new:
            v4_prefix, v6_prefix = self.allocate_prefixes(vlan)
        else:
            v4_prefix = Prefix.objects.get(vlan=vlan, prefix__family=4)
            v6_prefix = Prefix.objects.get(vlan=vlan, prefix__family=6)
            self.log_info(f"Skipping prefix allocation - VLAN already has prefixes assigned")
        
        self.set_access_ports(switch_name, vlan, interfaces)

        if v6_prefix is not None:
            self.log_success(f"🔗 v6 Prefix:  <a href=\"{v6_prefix.get_absolute_url()}\">{v6_prefix}</a>")
        if v4_prefix is not None:
            self.log_success(f"🔗 v4 Prefix:  <a href=\"{v4_prefix.get_absolute_url()}\">{v4_prefix}</a>")
        self.log_success(f"🔗 VLAN:       <a href=\"{vlan.get_absolute_url()}\">{vlan}</a>")
        interfaces_created = ""
        for interface in interfaces:
            interfaces_created += f"<a href=\"{interface.get_absolute_url()}\">{interface}</a> "
        self.log_success(f"✅ Successfully {'created' if vlan_is_new else 'applied configuration to'} leaf access on <a href=\"{switch_name.get_absolute_url()}\">{switch_name}</a> {interfaces_created}")

    def allocate_prefixes(self, vlan):
        v6_prefix = Prefix.objects.create(
            prefix=generatePrefix(FABRIC_V6_LEAF_CLIENTS_PREFIX(), 64),
            status=PrefixStatusChoices.STATUS_ACTIVE,
            role=FABRIC_CLIENTS_ROLE(),
            vrf=FABRIC_CLIENTS_VRF(),
            vlan=vlan
        )
        v4_prefix = Prefix.objects.create(
            prefix=generatePrefix(FABRIC_V4_LEAF_CLIENTS_PREFIX(), 25),
            status=PrefixStatusChoices.STATUS_ACTIVE,
            role=FABRIC_CLIENTS_ROLE(),
            vrf=FABRIC_CLIENTS_VRF(),
            vlan=vlan
        )
        self.log_info(f"Created prefixes: v4={v4_prefix}, v6={v6_prefix}")
        return v4_prefix, v6_prefix

    def create_vlan(self, switch):
        # Check if VLAN already exists for this switch
        try:
            vlan = VLAN.objects.get(
                name=switch.name,
                group=FABRIC_LEAF_VLAN_GROUP()
            )
            self.log_info(f"VLAN already exists: {vlan.name} (VID: {vlan.vid})")
            return vlan, False
        except VLAN.DoesNotExist:
            pass
        
        vid = FABRIC_LEAF_VLAN_GROUP().get_next_available_vid()
        vlan = VLAN.objects.create(
            name=switch.name,
            group=FABRIC_LEAF_VLAN_GROUP(),
            role=FABRIC_CLIENTS_ROLE(),
            vid=vid
        )
        vlan.save()
        
        self.log_info("Created VLAN")
        return vlan, True

    def set_access_ports(self, switch, vlan, interfaces):
        if len(interfaces) == 0:
            self.log_error(f"no interfaces found")
            return

        for interface in interfaces:
            interface.mode = 'access'
            interface.untagged_vlan = vlan
            interface.description = "C: Clients"
            interface.mark_connected = True
            interface.save()
        
        self.log_info("Configured traffic vlan on all client ports and marked as connected")

    def test_dependencies(self):
        all_ok = True
        checks = [
            (lambda: VLANGroup.objects.filter(slug=FABRIC_LEAF_VLAN_GROUP().slug).exists(),
             f"VLAN Group \"{FABRIC_LEAF_VLAN_GROUP().slug}\" doesn't exist."),
            (lambda: Role.objects.filter(slug=FABRIC_CLIENTS_ROLE().slug).exists(),
             f"Role \"{FABRIC_CLIENTS_ROLE().slug}\" doesn't exist."),
            (lambda: VRF.objects.filter(name=FABRIC_CLIENTS_VRF().name).exists(),
             f"VRF \"{FABRIC_CLIENTS_VRF().name}\" doesn't exist."),
        ]

        prefix_checks = [
            FABRIC_V4_LEAF_CLIENTS_PREFIX(),
            FABRIC_V6_LEAF_CLIENTS_PREFIX(),
        ]
        
        for prefix in prefix_checks:
            checks.append((
                lambda p=prefix: Prefix.objects.filter(prefix=p.prefix).exists(),
                f"Prefix \"{prefix.prefix}\" doesn't exist."
            ))
        
        for check_fn, error_msg in checks:
            if not check_fn():
                self.log_failure(error_msg)
                all_ok = False
        
        if not all_ok:
            raise AbortScript("Validation failed. See the script results/log for more information.")
        return all_ok

script = CreateLeafAccess
