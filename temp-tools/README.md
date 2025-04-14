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
