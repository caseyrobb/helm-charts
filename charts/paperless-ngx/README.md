# paperless-ngx

A Helm chart for [Paperless-ngx](https://docs.paperless-ngx.com/).

## TL;DR

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm dependency update charts/paperless-ngx
helm install paperless charts/paperless-ngx
```

## Prerequisites

- Kubernetes 1.25+
- Helm 3.10+
- For the default DB setup: the [CloudNativePG operator](https://cloudnative-pg.io/documentation/current/installation_upgrade/)
  installed in the cluster.
- A default StorageClass (or set one explicitly in values).

## Database options

Exactly one DB backend should be active. The chart supports three:

| Mode | Set values |
| --- | --- |
| CloudNativePG (default) | `cnpg.enabled=true` |
| External Postgres / MariaDB | `cnpg.enabled=false`, `externalDatabase.enabled=true`, populate `externalDatabase.*` or `externalDatabase.existingSecret` |
| Built-in SQLite (eval only) | `cnpg.enabled=false`, `externalDatabase.enabled=false` |

CNPG creates a Secret named `<cluster>-app` with `username`/`password` keys; the
chart wires those into `PAPERLESS_DBUSER` / `PAPERLESS_DBPASS` automatically.

## Broker

Bitnami Redis ships as a subchart and is enabled by default. To use an external
broker, set `redis.enabled=false` and either `externalRedis.url` or an
`externalRedis.existingSecret`.

## Persistence

Four PVCs are created by default (`data`, `media`, `consume`, `export`).
Override sizes, storage classes, or point at pre-existing PVCs via
`persistence.<name>.existingClaim`. Default access mode is `ReadWriteOnce`;
running more than one replica requires RWX volumes and disabling the embedded
consumer in Paperless.

## Common installs

External Postgres, no Redis subchart:

```bash
helm install paperless charts/paperless-ngx \
  --set cnpg.enabled=false \
  --set externalDatabase.enabled=true \
  --set externalDatabase.host=postgres.prod.svc \
  --set externalDatabase.user=paperless \
  --set externalDatabase.existingSecret=paperless-db \
  --set redis.enabled=false \
  --set externalRedis.enabled=true \
  --set externalRedis.url=redis://redis.prod.svc:6379
```

With an ingress:

```bash
helm install paperless charts/paperless-ngx \
  --set ingress.enabled=true \
  --set ingress.className=nginx \
  --set ingress.hosts[0].host=paperless.example.com \
  --set ingress.hosts[0].paths[0].path=/ \
  --set ingress.hosts[0].paths[0].pathType=Prefix \
  --set paperless.url=https://paperless.example.com
```

## Values

See [`values.yaml`](./values.yaml) for the complete list and inline docs.
