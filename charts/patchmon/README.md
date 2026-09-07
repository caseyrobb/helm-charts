# PatchMon - Enterprise Linux Patch & Server Management Platform

PatchMon is an enterprise-grade Linux patch & server management platform that provides comprehensive patch management, server monitoring, and remote desktop protocol (RDP) capabilities through Apache Guacamole integration. This Helm chart deploys PatchMon to Kubernetes clusters with all necessary dependencies including PostgreSQL for data storage and Redis for caching/sessions.

## Prerequisites

- Kubernetes 1.21+
- Helm 3.8+
- PersistentVolume support (for database and Redis storage)
- Ingress controller (optional, for external access)
- Prometheus operator (optional, for ServiceMonitor)

## Installation

### Default Installation

To install the chart with default settings:

```bash
helm repo add patchmon https://patchmon.github.io/helm-charts
helm repo update
helm install my-patchmon patchmon/patchmon
```

### Installation with Custom Values

```bash
helm install my-patchmon \
  --set config.corsOrigin="https://mydomain.com" \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=patchmon.mydomain.com \
  patchmon/patchmon
```

### Using Values File

Create a `custom-values.yaml` file and install:

```bash
helm install my-patchmon -f custom-values.yaml patchmon/patchmon
```

## Configuration

The following table lists the configurable parameters of the PatchMon chart and their default values.

| Parameter | Description | Default | Notes |
|-----------|-------------|---------|-------|
| `image.repository` | PatchMon server image repository | `ghcr.io/patchmon/patchmon-server` | |
| `image.tag` | PatchMon server image tag | `latest` | |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | |
| `containerPort` | Container port | `3000` | |
| `service.type` | Kubernetes service type | `ClusterIP` | |
| `service.port` | Kubernetes service port | `3000` | |
| `service.annotations` | Service annotations | `{}` | |
| `ingress.enabled` | Enable ingress | `false` | Requires ingress controller |
| `ingress.className` | Ingress class name | `""` | |
| `ingress.annotations` | Ingress annotations | `{}` | |
| `ingress.hosts` | Ingress host configurations | `[{host: patchmon.local, paths: [{path: /, pathType: Prefix]}]` | |
| `ingress.tls` | Ingress TLS configuration | `[]` | |
| `server.replicas` | Number of server replicas | `1` | |
| `server.podAnnotations` | Pod annotations | `{}` | |
| `server.podSecurityContext` | Pod security context | `{}` | |
| `server.securityContext` | Container security context | `{}` | |
| `server.resources.limits.cpu` | CPU limit | `1` | |
| `server.resources.limits.memory` | Memory limit | `2Gi` | |
| `server.resources.requests.cpu` | CPU request | `500m` | |
| `server.resources.requests.memory` | Memory request | `512Mi` | |
| `server.nodeSelector` | Node selector | `{}` | |
| `server.tolerations` | Tolerations | `[]` | |
| `server.affinity` | Affinity rules | `{}` | |
| `server.env` | Environment variables | `{}` | |
| `server.envFrom` | Environment variables from secrets/configmaps | `[]` | |
| `postgresql.enabled` | Enable embedded PostgreSQL | `true` | Set to false for external DB |
| `postgresql.image.registry` | PostgreSQL image registry | `docker.io` | |
| `postgresql.image.repository` | PostgreSQL image repository | `bitnami/postgresql` | |
| `postgresql.image.tag` | PostgreSQL image tag | `17-debian-12` | |
| `postgresql.auth.username` | PostgreSQL username | `patchmon_user` | |
| `postgresql.auth.password` | PostgreSQL password | `patchmon_password` | **Change in production!** |
| `postgresql.auth.database` | PostgreSQL database | `patchmon_db` | |
| `postgresql.primary.resources.limits.cpu` | PostgreSQL CPU limit | `1` | |
| `postgresql.primary.resources.limits.memory` | PostgreSQL memory limit | `1Gi` | |
| `postgresql.primary.resources.requests.cpu` | PostgreSQL CPU request | `250m` | |
| `postgresql.primary.resources.requests.memory` | PostgreSQL memory request | `256Mi` | |
| `redis.enabled` | Enable embedded Redis | `true` | Set to false for external Redis |
| `redis.architecture` | Redis architecture | `standalone` | |
| `redis.auth.enabled` | Redis authentication | `true` | |
| `redis.auth.password` | Redis password | `redis_password` | **Change in production!** |
| `redis.master.resources.limits.cpu` | Redis CPU limit | `500m` | |
| `redis.master.resources.limits.memory` | Redis memory limit | `512Mi` | |
| `redis.master.resources.requests.cpu` | Redis CPU request | `100m` | |
| `redis.master.resources.requests.memory` | Redis memory request | `128Mi` | |
| `guacd.enabled` | Enable Guacamole daemon | `true` | Required for RDP support |
| `guacd.image.repository` | Guacd image repository | `guacamole/guacd` | |
| `guacd.image.tag` | Guacd image tag | `1.6.0` | |
| `guacd.resources.limits.cpu` | Guacd CPU limit | `500m` | |
| `guacd.resources.limits.memory` | Guacd memory limit | `512Mi` | |
| `guacd.resources.requests.cpu` | Guacd CPU request | `100m` | |
| `guacd.resources.requests.memory` | Guacd memory request | `128Mi` | |
| `guacd.securityContext` | Guacd container security context | See values.yaml | readOnlyRootFilesystem, no privilege escalation |
| `persistence.postgresql.enabled` | Enable PostgreSQL persistence | `true` | |
| `persistence.postgresql.size` | PostgreSQL PVC size | `10Gi` | |
| `persistence.postgresql.storageClass` | PostgreSQL storage class | `""` | Uses default storage class |
| `persistence.postgresql.accessMode` | PostgreSQL access mode | `ReadWriteOnce` | |
| `persistence.redis.enabled` | Enable Redis persistence | `true` | |
| `persistence.redis.size` | Redis PVC size | `1Gi` | |
| `persistence.redis.storageClass` | Redis storage class | `""` | Uses default storage class |
| `persistence.redis.accessMode` | Redis access mode | `ReadWriteOnce` | |
| `config.corsOrigin` | CORS allowed origins | `"http://localhost:3000"` | Comma-separated URLs |
| `config.jwtSecret` | JWT signing secret | `""` | **Required! Generate with `openssl rand -hex 64`** |
| `config.sessionSecret` | Session encryption secret | `""` | **Required! Generate with `openssl rand -hex 64`** |
| `config.aiEncryptionKey` | AI encryption key | `""` | **Required! Generate with `openssl rand -hex 32`** |
| `config.postgresPassword` | PostgreSQL password override | `""` | Use for external PostgreSQL |
| `config.redisPassword` | Redis password override | `""` | Use for external Redis |
| `cleanup.enabled` | Enable cleanup cron jobs | `true` | Cleans old agent reports |
| `cleanup.schedule` | Cleanup job schedule | `"0 2 * * *"` | Daily at 2 AM |
| `cleanup.ssgSchedule` | SSG content update schedule | `"0 5 * * *"` | Daily at 5 AM |
| `serviceMonitor.enabled` | Enable Prometheus ServiceMonitor | `false` | Requires Prometheus operator |
| `serviceMonitor.namespace` | ServiceMonitor namespace | `monitoring` | |
| `serviceMonitor.labels` | ServiceMonitor labels | `{}` | |
| `serviceMonitor.interval` | Scrape interval | `30s` | |

## Configuration Examples

### Enabling Ingress

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    kubernetes.io/tls-acme: "true"
  hosts:
    - host: patchmon.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: patchmon-tls
      hosts:
        - patchmon.example.com
```

### Using External PostgreSQL

```yaml
postgresql:
  enabled: false

config:
  postgresPassword: "your-external-postgres-password"

extraEnv:
  - name: DATABASE_URL
    value: "postgresql://user:password@external-host:5432/patchmon_db"
```

### Using External Redis

```yaml
redis:
  enabled: false

config:
  redisPassword: "your-external-redis-password"

extraEnv:
  - name: REDIS_URL
    value: "redis://:password@external-host:6379/0"
```

### Custom Storage Classes

```yaml
persistence:
  postgresql:
    enabled: true
    size: 50Gi
    storageClass: "fast-ssd"
    accessMode: ReadWriteOnce
  redis:
    enabled: true
    size: 10Gi
    storageClass: "fast-ssd"
    accessMode: ReadWriteOnce
```

### High Availability Deployment

```yaml
server:
  replicas: 3
  resources:
    limits:
      cpu: 2
      memory: 4Gi
    requests:
      cpu: 1
      memory: 2Gi

affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app.kubernetes.io/name: patchmon
          topologyKey: kubernetes.io/hostname
```

### Enabling ServiceMonitor for Prometheus

```yaml
serviceMonitor:
  enabled: true
  namespace: monitoring
  labels:
    release: prometheus
  interval: 30s
```

## Upgrading

### Helm Upgrade

To upgrade to a newer version of the chart:

```bash
helm upgrade my-patchmon patchmon/patchmon --values custom-values.yaml
```

### Version-Specific Upgrade Notes

- **0.1.0 (appVersion 2.1.3)**: Initial release with embedded PostgreSQL and Redis, Guacamole for RDP support

### database Migration

When upgrading PatchMon, database migrations are automatically applied on pod startup. No manual intervention is required for standard upgrades.

**Important**: Always backup your data before upgrading:

```bash
# Backup PostgreSQL
kubectl exec -it <postgres-pod> -- pg_dump -U patchmon_user patchmon_db > backup.sql

# For production, use proper backup procedures
```

## Uninstall

To uninstall the PatchMon chart:

```bash
helm uninstall my-patchmon
```

**Note**: By default, persistent volumes are retained to prevent accidental data loss. To delete the persistent volumes:

```bash
# List PVCs
kubectl get pvc

# Delete PVCs manually
kubectl delete pvc data-my-patchmon-postgresql-0
kubectl delete pvc data-my-patchmon-redis-master-0

# Or use a script
kubectl delete pvc -l app.kubernetes.io/name=patchmon
```

## Troubleshooting

### Pod CrashLoopBackOff

Check logs:

```bash
kubectl logs <pod-name> --tail=100
kubectl logs <pod-name> -c guacd  # If guacd container exists
```

Common causes:
- Missing or invalid JWT/session secrets
- Database connection issues
- Resource constraints

### Cannot Access Web Interface

1. Check service is running:
   ```bash
   kubectl get svc <release-name>-patchmon
   ```

2. Check ingress (if enabled):
   ```bash
   kubectl get ingress <release-name>-patchmon
   ```

3. Port-forward for debugging:
   ```bash
   kubectl port-forward svc/<release-name>-patchmon 3000:3000
   ```

### Database Connection Failed

1. Verify PostgreSQL pod is running:
   ```bash
   kubectl get pods -l app.kubernetes.io/name=postgresql
   ```

2. Check PostgreSQL logs:
   ```bash
   kubectl logs <postgres-pod>
   ```

3. Verify password in `config.postgresPassword` matches the actual password

### Cleanup Jobs Not Running

Check cron job status:

```bash
kubectl get cronjob <release-name>-patchmon-cleanup
kubectl get jobs -l app.kubernetes.io/name=patchmon
```

View job logs:

```bash
kubectl logs <cleanup-job-pod>
```

### Resource Issues

Check resource usage:

```bash
kubectl top pods
kubectl top nodes
```

Adjust resources in `values.yaml`:

```yaml
server:
  resources:
    limits:
      cpu: 2
      memory: 4Gi
    requests:
      cpu: 1
      memory: 2Gi
```

## Contributing

We welcome contributions to PatchMon! Here's how you can help:

### Development Setup

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Run tests: `helm lint charts/patchmon`
5. Commit: `git commit -m 'Add some feature'`
6. Push: `git push origin feature/your-feature`
7. Open a Pull Request

### Code of Conduct

Please read and follow our [Code of Conduct](https://github.com/patchmon/patchmon/blob/main/CODE_OF_CONDUCT.md).

### Report Bugs

File issues at [GitHub Issues](https://github.com/patchmon/patchmon/issues).

### Security Issues

Please report security issues responsibly to security@patchmon.io.

## License

This project is licensed under the Apache License 2.0 - see the [LICENSE](https://github.com/patchmon/patchmon/blob/main/LICENSE) file for details.

## Acknowledgements

- PatchMon uses [Bitnami PostgreSQL](https://github.com/bitnami/charts/tree/main/bitnami/postgresql) and [Redis](https://github.com/bitnami/charts/tree/main/bitnami/redis) sub-charts
- Guacamole integration powered by [Apache Guacamole](https://guacamole.apache.org/)
