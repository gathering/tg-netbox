# tg25-netbox

Dette repoet setter opp basisen i Netbox, og her bor også templates.

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
