Denne mappa inneholder compose override fil og env filer relatert til oppsett av netbox.
Legg disse i samme mappe som docker-repoet til netbox og kjør docker-compose fila inkludert i det repoet. Kjør deretter docker-compose.override.yml for å legge på LDAP, NGINX og Acme.

Bruk [imaget vi har bygget selv](https://github.com/orgs/gathering/packages/container/package/netbox-docker) for å få med aktiverte plugins.

Legg til nye plugins der via [netbox-docker sin dokumentasjon](https://github.com/netbox-community/netbox-docker/wiki/Using-Netbox-Plugins), og så auto-bygges det en ny versjon som blir tilgjengeliggjort på [https://github.com/orgs/gathering/packages/container/package/netbox-docker](https://github.com/orgs/gathering/packages/container/package/netbox-docker), ved å endre i [Dockerfile-Plugins](https://github.com/gathering/netbox-docker/blob/plugin-build/Dockerfile-Plugins), [plugin_requirements.txt](https://github.com/gathering/netbox-docker/blob/plugin-build/plugin_requirements.txt) osv.

Husk å endre og aktivere konfigurasjon i `configurations/*.py` filene i netbox-docker mappa på netbox sørvern.
