# TG-netbox Ansible

Denne mappa inneholder Ansible-playbooks for å automatisere import av device types og patchpaneler i NetBox.

## get_device_types.yaml

Ser hvilke modeller som ligger i `model.yaml` og laster automatisk ned device-type-filer for disse modellene fra det offisielle
[NetBox device type-biblioteket](https://github.com/netbox-community/devicetype-library).

Alle device-type-filene lagres i mappen `\device_types\`.

## import_device_types.yaml

Ser etter alle filer i mappen `\device_types\` som ender på `.yaml`, og sender disse én og én til `import_single_devicetype.yaml`,
som deretter laster hver fil opp som en device type i NetBox.

## import_patch_panels.yaml

Ser etter alle filer i mappen `\patch_panels\` som ender på `.yaml`, og sender disse én og én til
`restAPI_upload_patch_panel.yaml`, som deretter laster filene opp som device types i NetBox.

Det benyttes ikke samme playbook som for andre device types, ettersom patchpanelene inneholder port-typer som ikke er støttet i
`netbox.netbox`-biblioteket i Ansible.
