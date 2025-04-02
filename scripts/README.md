# TG25 Scripts

## create-switch

Create a new access switch and 

## Example run with API:

```
curl -X POST \
-H "Authorization: Token 14ef292da3c0564c591cd39eb22fa2cbab75b141" \
-H "Content-Type: application/json" \
-H "Accept: application/json; indent=4" \
https://netbox.tg25.tg.no/api/extras/scripts/create-switch.CreateSwitch/ \
--data-binary @- << EOF
{"data": {
        "switch_name": "e1.test",
        "device_type": "EX2200-48T-4G",
        "device_role": "Access switch",
        "uplink_type": "1G RJ45",
        "destination_device_a" : "d1-ring-noc",
        "destination_device_b" : "",
        "destination_interfaces" : "ge-0/0/46"
        }, "commit": true}
EOF```