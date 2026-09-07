# paperless-ngx

[paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) is a document management system that transforms your physical documents into a searchable online archive.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2+
- PV provisioner support in the underlying infrastructure

## Installation

### Add the repository

```bash
helm repo add caseyrobb https://caseyrobb.github.io/helm-charts
helm repo update
```

### Install the chart

```bash
helm install my-paperless caseyrobb/paperless-ngx
```

### Install with custom values

```bash
helm install my-paperless caseyrobb/paperless-ngx \
  --set postgresql.password=secretpassword \
  --set config.paperless_secret_key=mysecretkey
```

## Configuration

The following table lists the configurable parameters of the paperless-ngx chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ghcr.io/paperless-ngx/paperless-ngx` |
| `image.tag` | Image tag | `3.1.3` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.port` | Service port | `8000` |
| `postgresql.enabled` | Enable embedded PostgreSQL | `true` |
| `postgresql.host` | External PostgreSQL host | `""` |
| `postgresql.port` | PostgreSQL port | `5432` |
| `postgresql.database` | PostgreSQL database | `paperless` |
| `postgresql.username` | PostgreSQL username | `paperless` |
| `postgresql.password` | PostgreSQL password | `""` |
| `redis.enabled` | Enable embedded Redis | `true` |
| `redis.host` | External Redis host | `""` |
| `redis.port` | Redis port | `6379` |
| `persistence.enabled` | Enable persistence | `true` |
| `persistence.size` | PVC size | `10Gi` |
| `resources.limits.cpu` | CPU limit | `500m` |
| `resources.limits.memory` | Memory limit | `512Mi` |
| `config.paperless_url` | Paperless URL | `http://localhost:8000` |
| `config.paperless_secret_key` | Django secret key | Generated randomly |

### Ingress Configuration

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: paperless.example.com
      paths:
        - path: /
          pathType: Prefix
```

### Custom Storage Class

```yaml
persistence:
  storageClass: "premium-ssd"
  size: 50Gi
```

### External Database

```yaml
postgresql:
  enabled: false
  host: my-postgres.example.com
  port: 5432
  database: paperless
  username: paperless
  password: "mypassword"
  existingSecret: "paperless-db-secret"
  existingSecretKey: "password"
```

### Mail Configuration

```yaml
config:
  paperless_mailhost: "smtp.example.com"
  paperless_mailport: 587
  paperless_mailuser: "paperless@example.com"
  paperless_mailpassword: "myappassword"
  paperless_mail_use_tls: "true"
```

## Upgrade

```bash
helm upgrade my-paperless caseyrobb/paperless-ngx -f values.yaml
```

## Uninstall

```bash
helm uninstall my-paperless
```

To delete the PVCs:

```bash
kubectl delete pvc -l app.kubernetes.io/name=paperless-ngx
```

## Troubleshooting

### Pods not starting

Check logs:

```bash
kubectl logs -l app.kubernetes.io/name=paperless-ngx
```

### Database connection issues

Verify PostgreSQL is running:

```bash
kubectl get pods -l app.kubernetes.io/name=postgresql
```

Check environment variables in the pod:

```bash
kubectl exec -it <pod-name> -- env | grep PAPERLESS_DB
```

### Memory issues

Increase resources:

```yaml
resources:
  limits:
    memory: 1Gi
  requests:
    memory: 512Mi
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
