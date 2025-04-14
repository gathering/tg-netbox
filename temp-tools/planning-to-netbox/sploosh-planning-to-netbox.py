from pprint import pprint

dataset = {}

with open('patchlist.txt') as f:
    for line in f.read().splitlines():
        switch, b, c, d, e = line.split(' ')
        dataset[switch] = {'name': switch}
        dataset[switch]['distro'] = b
        dataset[switch]['uplink1'] = c
        dataset[switch]['uplink2'] = d
        dataset[switch]['uplink3'] = e

with open('switches.txt') as f:
    for line in f.read().splitlines():
        switch, v4, v6, v4_mgmt, v6_mgmt, vlan, distro = line.strip().split(' ')
        dataset[switch]['v4'] = v4
        dataset[switch]['v6'] = v6
        dataset[switch]['v4_mgmt'] = v4_mgmt
        dataset[switch]['v6_mgmt'] = v6_mgmt
        dataset[switch]['vlan'] = vlan

pprint(dataset)
