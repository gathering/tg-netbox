import json

from extras.scripts import *

from dcim.models import Device, DeviceType, DeviceRole, Interface
from dcim.choices import InterfaceTypeChoices, InterfaceModeChoices

from ipam.models import VLAN, Role, VRF

from extras.models import Tag

from utilities.exceptions import AbortScript

UPLINK_TYPES = (
    (InterfaceTypeChoices.TYPE_1GE_FIXED, '1G RJ45'),
    (InterfaceTypeChoices.TYPE_2GE_FIXED, '2.5G RJ45'),
    (InterfaceTypeChoices.TYPE_5GE_FIXED, '5G RJ45')
)

# Device role slug for leaf switches
DEVICE_ROLE_LEAF = "leaf"
DEVICE_ROLE_L2LEAF = "l2-leaf"

# Don't default if the defaults don't exist
try:
    DEFAULT_SWITCH_NAME = Device.objects.get(name='d1-noc')
except:
    DEFAULT_SWITCH_NAME = None

class CreateAccessPointPort(Script):
    class Meta:
        name = "Create Access Point port on Arista Leaf Switch"
        description = ""
        commit_default = True
        fieldsets = ""
        scheduling_enabled = False

    switch_name = ObjectVar(
        description="Switch",
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
        description="What type of interface should be configured to access point port",
        choices=UPLINK_TYPES,
        default=[InterfaceTypeChoices.TYPE_2GE_FIXED, InterfaceTypeChoices.TYPE_5GE_FIXED]
    )

    interfaces = MultiObjectVar(
        description="Interface(s)",
        model=Interface,
        required=True,
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

        WIFI_1337 = VLAN.objects.get(name="WIFI-1337")
        WIFI_1338 = VLAN.objects.get(name="WIFI-1338")
        WIFI_1339 = VLAN.objects.get(name="WIFI-1339")
        WIFI_1340 = VLAN.objects.get(name="WIFI-1340")
        WIFI_1341 = VLAN.objects.get(name="WIFI-1341")
        WIFI_LEGACY = VLAN.objects.get(name="WIFI-LEGACY")
        AP_MGMT_VLAN = VLAN.objects.get(name="ap-mgmt")

        WIFI_VLANS = [WIFI_1337, WIFI_1338, WIFI_1339, WIFI_1340, WIFI_1341, WIFI_LEGACY]

        self.set_access_point_ports(switch_name, interfaces, AP_MGMT_VLAN, WIFI_VLANS)

        interfaces_created = ""
        for interface in interfaces:
            interfaces_created += f"<a href=\"{interface.get_absolute_url()}\">{interface}</a> "
        self.log_success(f"✅ Successfully created access point ports on <a href=\"{switch_name.get_absolute_url()}\">{switch_name}</a> {interfaces_created}")

    def set_access_point_ports(self, switch, interfaces, ap_mgmt_vlan, wifi_vlans):
        if len(interfaces) == 0:
            self.log_error(f"no interfaces found")
            return

        for interface in interfaces:
            interface.mode = "tagged"
            interface.untagged_vlan = ap_mgmt_vlan
            interface.description = "W: Access Point"
            interface.mark_connected = True
            interface.save()
            interface.tagged_vlans.set(wifi_vlans)
        
        self.log_info("Configured all access point vlans on ports and marked as connected")

    def test_dependencies(self):
        all_ok = True
        vlan_names = ["WIFI-1337", "WIFI-1338", "WIFI-1339", "WIFI-1340", "WIFI-1341", "WIFI-LEGACY", "ap-mgmt"]

        for vlan_name in vlan_names:
            if not VLAN.objects.filter(name=vlan_name).exists():
                self.log_failure(f"VLAN '{vlan_name}' doesn't exist.")
                all_ok = False
        
        if not all_ok:
            raise AbortScript("Validation failed. See the script results/log for more information.")
        return all_ok

script = CreateAccessPointPort
