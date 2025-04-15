from pprint import pprint
import requests
import sys, time

dataset = {}

with open('patchlist.txt') as f:
    for line in f.read().splitlines():
        switch, b, c, d, e = line.split('\t')
        dataset[switch] = {'name': switch}
        dataset[switch]['distro'] = b
        dataset[switch]['uplink1'] = c
        dataset[switch]['uplink2'] = d
        dataset[switch]['uplink3'] = e

n = 0
headers = {"Authorization": "Token <secret>","Content-Type": "application/json","Accept": "application/json"}
for _, lol in dataset.items():
    print(f'\n\nDoing {lol['name']}')
    n += 1
    params = {
        'data': {
            'switch_name': lol['name'],
            'device_type': 'EX2200-48T-4G',
            'device_role': 'Access switch',
            'uplink_type': '2.5G RJ45',
            'destination_device_a': lol['distro'],
            'destination_device_b': '',
            'destination_interfaces': ','.join([
                lol['uplink1'],
                lol['uplink2'],
                lol['uplink3']
            ])
        },
        'commit': 'true'
    }
    resp = requests.post('https://netbox.tg25.tg.no/api/extras/scripts/create-switch.CreateSwitch/', headers = headers, json=params)
    pprint(resp.json())
    time.sleep(3)