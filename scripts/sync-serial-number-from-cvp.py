import os
import requests

from dcim.models import Device, Manufacturer
from django.db.models import Q
from extras.scripts import *
from utilities.exceptions import AbortScript

cvp_inventory_api_url = "https://www.cv-prod-euwest-2.arista.io/cvpservice/inventory/devices"
cvp_inventory_api_token = os.getenv("NETBOX_CVP_API_TOKEN", None)

class SyncSerialFromCVP(Script):
    class Meta:
        name = "Sync Serial numbers from CVP"
        description = "Sync serial number for arista stuff from cvp"
        commit_default = True
        fieldsets = ""
        scheduling_enabled = True

    def run(self, data, commit):
        if not cvp_inventory_api_token:
            raise AbortScript("Missing API token for CVP. Set the 'NETBOX_CVP_API_TOKEN' environment variable.")

        arista = None
        try:
            arista = Manufacturer.objects.get(name="Arista")
        except Manufacturer.DoesNotExist:
            raise AbortScript("Arista manufacturer does not exist, no devices to sync serial number for")

        arista_devices_in_netbox = Device.objects.filter(device_type__manufacturer_id=arista.id).filter(Q(serial__isnull=True) | Q(serial=''))
        devices_in_cpv = []
        if arista_devices_in_netbox.exists():
            try:
                devices_in_cpv = get_devices_from_cvp(cvp_inventory_api_token)
            except Exception as e:
                raise AbortScript(f"CVP returned an error: {e}")
            if not devices_in_cpv:
                raise AbortScript("No devices found in CVP")

        for device in arista_devices_in_netbox:
            self.log_info(f"looking for serial number for {device.name}")
            for cvp_device in devices_in_cpv:
                if device.name == cvp_device['hostname']:
                    serial = cvp_device['serialNumber']
                    self.log_info(f'Found serial {serial}')
                    device.serial = serial
                    device.save()


def get_devices_from_cvp(token):
    r = requests.get(cvp_inventory_api_url, headers={
        'authorization': f'Bearer {token}',
    })
    return r.json()


script = SyncSerialFromCVP
