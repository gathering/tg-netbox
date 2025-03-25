# tg25-netbox

Dette repoet setter opp basisen i Netbox, og her bor også templates.

Testing av templates gjøres slik:

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