# Whats this?
Quick and dirty scripts to manipulate netbox as a single use thing. Wrinte, run, throw away.

## fix-vlan-names.py
Replaces "." with "-" in vlan names

## fix-descriptions.py
Replaces something in interface descriptions with something else. Regex

    j@j-x1:~/tg25/tg25-netbox$ python3 temp-tools/fix-descriptions.py 
    G: e1.bird ge-0/0/44 (ae10) -> G: e1-bird ge-0/0/44 (ae10)
    G: e1.bird ge-0/0/45 (ae10) -> G: e1-bird ge-0/0/45 (ae10)
    G: e2.bird ge-0/0/44 (ae11) -> G: e2-bird ge-0/0/44 (ae11)
    G: e2.bird ge-0/0/45 (ae11) -> G: e2-bird ge-0/0/45 (ae11)
    G: e1.bula ge-0/0/44 (ae12) -> G: e1-bula ge-0/0/44 (ae12)
    G: e1.bula ge-0/0/45 (ae12) -> G: e1-bula ge-0/0/45 (ae12)
    G: e1.taakeheimen ge-0/0/44 (ae13) -> G: e1-taakeheimen ge-0/0/44 (ae13)
    G: e1.taakeheimen ge-0/0/45 (ae13) -> G: e1-taakeheimen ge-0/0/45 (ae13)

## planning-to-netbox/sploosh-planning-to-netbox.py 
Adds all the switches created by "planning" (see tgmanage repo) to netbox via the "create switch" script

    j@j-x1:~/tg25/tg25-netbox/temp-tools/planning-to-netbox$ python3 sploosh-planning-to-netbox.py
    {'e1-1': {'distro': 'd1-floor',
              'name': 'e1-1',
              'uplink1': 'Ethernet1',
              'uplink2': 'Ethernet2',
              'uplink3': 'Ethernet49',
              'v4': '88.92.0.0/26',
              'v4_mgmt': '151.216.130.2/24',
              'v6': '2a06:5844:e:11::/64',
              'v6_mgmt': '2a06:5841:f:10:1::2/64',
              'vlan': '1011'},
     'e1-2': {'distro': 'd1-floor',
              'name': 'e1-2',
              'uplink1': 'Ethernet2',
              'uplink2': 'Ethernet3',
              'uplink3': 'Ethernet50',
              'v4': '88.92.0.64/26',
              'v4_mgmt': '151.216.130.3/24',
              'v6': '2a06:5844:e:12::/64',
              'v6_mgmt': '2a06:5841:f:10:1::3/64',
              'vlan': '1012'},
    [...]

Then something something(tm) to post it to Netbox, with some error handling 