# tg25-netbox

Dette repoet setter opp basisen i Netbox, og her bor også templates og scripts for provisjonering

## Requriements

```
- Bitwarden cli - for å hente secrets fra vaultwarden
- Direnv - for å laste inn hemligheter i environment
- Terraform - for å kjøre terraform
- Python3 - for å kjøre test av templates
- Pipenv - for å kjøre test av templates
- junoser - for å validere junos config
```

## Deploy templates

Terraform brukes for å holde config templates up to date i netbox.

```shell
terraform apply
```

## Testing av templates


Installer python avhengigheter

```
$ pipenv install
```

Bruk pipenv for å kjøre programmet:

```
$ pipenv run python3 test-template.py <navn på switch> <navn på template fil>
```

Eksempel
```
$ pipenv run python3 test-template.py e1.test-UFARBM test2.j2

```

Validere templates med junoser
```
make juniper | tail -n +2 | junoser -c
```

## Flytskjema
![flytskjema](/documentation/flowchart.png)

## Netbox sync av scripts o.l.
Når man har pushet ny kode til repoet i Github så må man inn i Netbox og synce.

Operations -> Integrations -> Data Sources -> tg25-netbox -> Trykk på "sync"

## Hvordan grave i netbox-variabler
### Via "nbshell"
1) Logge inn på Netbox sitt shell i docker

        ssh netbox.tg25.tg.no
        docker exec -it $(docker ps | grep prod-netbox-1 | cut -d' ' -f1) ./manage.py nbshell
2) bruk `lsmodels()` og `help()` for å navigere. F.eks. slik:

        >>> help(Device.objects.first())
        >>> Device.objects.get(name="d1-1-roof").interfaces.first().cable
        <Cable: #33>      
3) Juks for å finne tilgjengelige properties i et objekt: putt inn en gibberish key

        >>> Device.objects.get(asdf='2')
        ...
        raise FieldError(
        django.core.exceptions.FieldError: Cannot resolve keyword 'asdf' into field. Choices are: airflow, asset_tag, bookmarks, cabletermination, cluster, cluster_id, comments, config_template, config_template_id, console_port_count, console_server_port_count, consoleports, consoleserverports, contacts, coordinate, created, custom_field_data, description, device_bay_count, device_type, device_type_id, devicebays, face, front_port_count, frontports, id, images, interface_count, interfaces, inventory_item_count, inventoryitems, journal_entries, last_updated, latitude, local_context_data, location, location_id, longitude, module_bay_count, modulebays, modules, name, oob_ip, oob_ip_id, parent_bay, platform, platform_id, position, power_outlet_count, power_port_count, poweroutlets, powerports, primary_ip4, primary_ip4_id, primary_ip6, primary_ip6_id, rack, rack_id, rear_port_count, rearports, role, role_id, serial, services, site, site_id, status, subscriptions, tagged_items, tags, tenant, tenant_id, vc_master_for, vc_position, vc_priority, vdcs, virtual_chassis, virtual_chassis_id, virtual_machines