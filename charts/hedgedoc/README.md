# hedgedoc

[HedgeDoc](https://hedgedoc.org) lets you create real-time collaborative
markdown notes (fork of CodiMD). This chart is a house-maintained fork of the
[adfinis hedgedoc chart](https://github.com/adfinis/helm-charts) templates with
the bundled Bitnami-style Postgres subchart replaced by a native
[CloudNativePG](https://cloudnative-pg.io) `Cluster` CR integration.

## Highlights

- `cnpg.enabled=true` (default): renders a CNPG `Cluster` CR, wires
  `CMD_DB_HOST/PORT/NAME/USER` to the `<cluster>-rw` service and pulls
  `CMD_DB_PASSWORD` from the CNPG-generated `<cluster>-app` secret.
- `cnpg.enabled=false` + `externalDatabase.*`: point at any external
  Postgres; password comes from `existingSecret`.
- Optional Barman Cloud backup block on the CNPG Cluster (`cnpg.backup.*`).
- Media uploads on a PVC; `wait-for-db` init container avoids startup races.

## Required values

- `CMD_DOMAIN` via `hedgedoc.env` (e.g. `hedgedoc.example.com`).
- A Secret providing `CMD_SESSION_SECRET` (and `CMD_DB_PASSWORD` when using
  `externalDatabase`) — name it with `existingSecret` or let the chart default
  to `<fullname>-secrets` (manage it out-of-band, e.g. ExternalSecret).

## Requirements

- Kubernetes >= 1.24
- When `cnpg.enabled=true`: CloudNativePG operator installed in the cluster.

## Values

See `values.yaml`; upstream chart: adfinis/helm-charts `charts/hedgedoc`.
