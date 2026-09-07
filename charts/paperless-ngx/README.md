# Paperless-ngx Helm Chart

A Helm chart for [Paperless-ngx](https://docs.paperless-ngx.com/), a community-supported open-source document management system that transforms your physical documents into a searchable, encrypted, and organized digital library.

## Prerequisites

- Kubernetes 1.25+
- Helm 3.11+
- PersistentVolume provisioner support in the underlying infrastructure

## Installation

### Installing the Chart

```bash
# Add the repository (if not already added)
helm repo add paperless-ngx https://paperless-ngx.github.io/helm-chart/
helm repo update

# Install with default values
helm install my-paperless paperless-ngx/paperless-ngx

# Install with custom values
helm install my-paperless paperless-ngx/paperless-ngx -f values.yaml
```

### Installing from Local Directory

```bash
helm install my-paperless ./charts/paperless-ngx
```

## Configuration

The following table lists the configurable parameters of the Paperless-ngx chart and their default values.

| Parameter | Description | Default | Notes |
|-----------|-------------|---------|-------|
| `nameOverride` | Override the chart name | `""` | Used for resource naming |
| `fullnameOverride` | Override the full release name | `""` | Used for resource naming |
| `image.repository` | Paperless-ngx image repository | `ghcr.io/paperless-ngx/paperless-ngx` | |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | |
| `image.tag` | Image tag | `""` | Defaults to `.Chart.AppVersion` when unset |
| `imagePullSecrets` | Image pull secrets | `[]` | List of secret names |
| `replicaCount` | Number of replicas | `1` | See notes below |
| `podSecurityContext` | Pod-level security context | See values.yaml | fsGroup, runAsNonRoot, etc. |
| `securityContext` | Container security context | See values.yaml | allowPrivilegeEscalation, capabilities |
| `serviceAccount.create` | Create service account | `true` | |
| `serviceAccount.automount` | Automount service account token | `true` | |
| `serviceAccount.annotations` | Service account annotations | `{}` | |
| `serviceAccount.name` | Service account name | `""` | Uses fullname if empty |
| `paperless.url` | Base URL for Paperless | `""` | Required for proper link generation |
| `paperless.timeZone` | Default timezone | `"UTC"` | e.g., `"America/New_York"` |
| `paperless.ocrLanguage` | OCR language | `"eng"` | Use 3-letter ISO 639-2 codes |
| `paperless.allowedHosts` | Allowed hosts list | `"*"` | Comma-separated list |
| `paperless.csrfTrustedOrigins` | CSRF trusted origins | `""` | Comma-separated with scheme |
| `paperless.extraEnv` | Extra environment variables | `{}` | Additional PAPERLESS_* vars |
| `admin.user` | Admin username | `"admin"` | |
| `admin.password` | Admin password | `""` | Generated if empty |
| `admin.email` | Admin email | `""` | |
| `admin.existingSecret` | Secret containing admin credentials | `""` | Overrides user/password/email |
| `secretKey.value` | Django SECRET_KEY | `""` | Generated if empty |
| `secretKey.existingSecret` | Secret containing secret key | `""` | External secret name |
| `service.type` | Service type | `ClusterIP` | ClusterIP, NodePort, LoadBalancer |
| `service.port` | Service port | `80` | |
| `service.targetPort` | Container port | `8000` | |
| `service.annotations` | Service annotations | `{}` | |
| `ingress.enabled` | Enable Ingress | `false` | |
| `ingress.className` | Ingress class name | `""` | |
| `ingress.annotations` | Ingress annotations | `{}` | |
| `ingress.hosts` | Ingress hosts | See values.yaml | Array of host/path configs |
| `ingress.tls` | Ingress TLS | `[]` | TLS configuration |
| `persistence.data.enabled` | Enable data PVC | `true` | SQLite, search index, model |
| `persistence.data.size` | Data PVC size | `5Gi` | |
| `persistence.data.storageClass` | Data PVC storage class | `""` | Empty uses default |
| `persistence.data.accessModes` | Data PVC access modes | `["ReadWriteOnce"]` | |
| `persistence.data.existingClaim` | Existing data PVC name | `""` | Uses existing claim |
| `persistence.media.enabled` | Enable media PVC | `true` | Documents, thumbnails |
| `persistence.media.size` | Media PVC size | `20Gi` | |
| `persistence.media.storageClass` | Media PVC storage class | `""` | Empty uses default |
| `persistence.media.accessModes` | Media PVC access modes | `["ReadWriteOnce"]` | |
| `persistence.media.existingClaim` | Existing media PVC name | `""` | |
| `persistence.consume.enabled` | Enable consume PVC | `true` | Inbox for new files |
| `persistence.consume.size` | Consume PVC size | `2Gi` | |
| `persistence.consume.storageClass` | Consume PVC storage class | `""` | Empty uses default |
| `persistence.consume.accessModes` | Consume PVC access modes | `["ReadWriteOnce"]` | |
| `persistence.consume.existingClaim` | Existing consume PVC name | `""` | |
| `persistence.export.enabled` | Enable export PVC | `false` | Manual export target |
| `persistence.export.size` | Export PVC size | `5Gi` | |
| `persistence.export.storageClass` | Export PVC storage class | `""` | Empty uses default |
| `persistence.export.accessModes` | Export PVC access modes | `["ReadWriteOnce"]` | |
| `persistence.export.existingClaim` | Existing export PVC name | `""` | |
| `resources` | Pod resources | `{}` | limits and requests |
| `nodeSelector` | Node selector | `{}` | |
| `tolerations` | Tolerations | `[]` | |
| `affinity` | Affinity rules | `{}` | |
| `podAnnotations` | Pod annotations | `{}` | |
| `podLabels` | Pod labels | `{}` | |
| `livenessProbe.enabled` | Enable liveness probe | `true` | |
| `livenessProbe.httpGet.path` | Liveness probe path | `/accounts/login/` | |
| `livenessProbe.initialDelaySeconds` | Liveness initial delay | `60` | |
| `livenessProbe.periodSeconds` | Liveness period | `30` | |
| `livenessProbe.timeoutSeconds` | Liveness timeout | `10` | |
| `livenessProbe.failureThreshold` | Liveness failure threshold | `5` | |
| `readinessProbe.enabled` | Enable readiness probe | `true` | |
| `readinessProbe.httpGet.path` | Readiness probe path | `/accounts/login/` | |
| `readinessProbe.initialDelaySeconds` | Readiness initial delay | `20` | |
| `readinessProbe.periodSeconds` | Readiness period | `10` | |
| `readinessProbe.timeoutSeconds` | Readiness timeout | `5` | |
| `readinessProbe.failureThreshold` | Readiness failure threshold | `5` | |
| `startupProbe.enabled` | Enable startup probe | `true` | |
| `startupProbe.httpGet.path` | Startup probe path | `/accounts/login/` | |
| `startupProbe.periodSeconds` | Startup period | `10` | |
| `startupProbe.timeoutSeconds` | Startup timeout | `5` | |
| `startupProbe.failureThreshold` | Startup failure threshold | `60` | |
| `database.engine` | Database engine | `"postgresql"` | postgresql, mariadb, sqlite |
| `cnpg.enabled` | Enable CloudNativePG | `true` | PostgreSQL cluster |
| `cnpg.clusterName` | CNPG cluster name | `""` | Defaults to `<release>-pg` |
| `cnpg.instances` | Number of CNPG instances | `1` | |
| `cnpg.imageName` | CNPG image | `"ghcr.io/cloudnative-pg/postgresql:16.4"` | |
| `cnpg.storage.size` | CNPG storage size | `10Gi` | |
| `cnpg.storage.storageClass` | CNPG storage class | `""` | Empty uses default |
| `cnpg.database` | CNPG database name | `"paperless"` | |
| `cnpg.owner` | CNPG owner user | `"paperless"` | |
| `cnpg.bootstrapSecret` | CNPG bootstrap secret | `""` | Existing secret name |
| `cnpg.resources` | CNPG resources | `{}` | |
| `cnpg.monitoring.enabled` | Enable CNPG monitoring | `false` | |
| `cnpg.backup.enabled` | Enable CNPG backup | `false` | |
| `cnpg.backup.retentionPolicy` | Backup retention | `"30d"` | |
| `cnpg.backup.barmanObjectStore` | Barman config | `{}` | S3/GCS config |
| `externalDatabase.enabled` | Enable external DB | `false` | |
| `externalDatabase.host` | External DB host | `""` | Required if enabled |
| `externalDatabase.port` | External DB port | `5432` | |
| `externalDatabase.database` | External DB name | `"paperless"` | |
| `externalDatabase.user` | External DB user | `"paperless"` | |
| `externalDatabase.password` | External DB password | `""` | |
| `externalDatabase.existingSecret` | External DB secret | `""` | |
| `externalDatabase.sslmode` | PostgreSQL SSL mode | `""` | disable, prefer, require, etc. |
| `redis.enabled` | Enable embedded Redis | `true` | Bitnami subchart |
| `redis.architecture` | Redis architecture | `"standalone"` | |
| `redis.auth.enabled` | Redis auth enabled | `false` | |
| `redis.master.persistence.enabled` | Redis persistence | `true` | |
| `redis.master.persistence.size` | Redis size | `2Gi` | |
| `externalRedis.enabled` | Enable external Redis | `false` | |
| `externalRedis.url` | External Redis URL | `""` | Required if enabled |
| `externalRedis.existingSecret` | External Redis secret | `""` | |
| `gotenberg.enabled` | Enable Gotenberg | `true` | Office conversion |
| `gotenberg.image.repository` | Gotenberg image | `docker.io/gotenberg/gotenberg` | |
| `gotenberg.image.tag` | Gotenberg tag | `"8.27"` | |
| `gotenberg.image.pullPolicy` | Gotenberg pull policy | `IfNotPresent` | |
| `gotenberg.replicaCount` | Gotenberg replicas | `1` | |
| `gotenberg.service.port` | Gotenberg port | `3000` | |
| `gotenberg.args` | Gotenberg args | See values.yaml | |
| `gotenberg.resources` | Gotenberg resources | `{}` | |
| `tika.enabled` | Enable Tika | `true` | Document parsing |
| `tika.image.repository` | Tika image | `docker.io/apache/tika` | |
| `tika.image.tag` | Tika tag | `"latest"` | |
| `tika.image.pullPolicy` | Tika pull policy | `IfNotPresent` | |
| `tika.replicaCount` | Tika replicas | `1` | |
| `tika.service.port` | Tika port | `9998` | |
| `tika.resources` | Tika resources | `{}` | |

## Configuration Examples

### Enabling Ingress

```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    kubernetes.io/ingress.class: nginx
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: paperless.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: paperless-tls
      hosts:
        - paperless.example.com
```

### Configuring PostgreSQL with External Database

```yaml
cnpg:
  enabled: false

externalDatabase:
  enabled: true
  host: my-postgres.example.com
  port: 5432
  database: paperless
  user: paperless
  existingSecret: paperless-db-creds  # Secret with 'username' and 'password' keys
```

### Configuring Redis with Existing Secret

```yaml
redis:
  enabled: false

externalRedis:
  enabled: true
  existingSecret: paperless-redis-creds  # Secret with 'PAPERLESS_REDIS' key
  existingSecretKey: PAPERLESS_REDIS
```

### Setting Up PVC with Custom Storage Class

```yaml
persistence:
  data:
    size: 10Gi
    storageClass: fast-ssd
  media:
    size: 50Gi
    storageClass: fast-ssd
  consume:
    size: 5Gi
    storageClass: standard
```

### Enabling Autoscaling

```yaml
replicaCount: 2  # Must be > 1 for autoscaling

autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
```

### Configuring Mail Settings

```yaml
paperless:
  extraEnv:
    PAPERLESS_MAILHOST: "smtp.example.com"
    PAPERLESS_MAILPORT: "587"
    PAPERLESS_MAILUSER: "paperless@example.com"
    PAPERLESS_MAIL_USE_TLS: "true"

secretKey:
  value: "your-secret-key-here"
```

### Enabling CloudNativePG with Backup

```yaml
cnpg:
  enabled: true
  instances: 3
  storage:
    size: 50Gi
    storageClass: premium-ssd
  backup:
    enabled: true
    retentionPolicy: "90d"
    barmanObjectStore:
      destinationPath: s3://my-bucket/paperless-backups
      s3Credentials:
        accessKeyId:
          name: backup-credentials
          key: ACCESS_KEY_ID
        secretAccessKey:
          name: backup-credentials
          key: ACCESS_KEY_SECRET
```

### Using External Secrets for Sensitive Data

```yaml
# Create secrets first:
# kubectl create secret generic paperless-secrets \
#   --from-literal=PAPERLESS_SECRET_KEY=your-secret-key \
#   --from-literal=PAPERLESS_ADMIN_USER=admin \
#   --from-literal=PAPERLESS_ADMIN_PASSWORD=your-password \
#   --from-literal=PAPERLESS_ADMIN_MAIL=admin@example.com

admin:
  existingSecret: paperless-secrets
  existingSecretUserKey: PAPERLESS_ADMIN_USER
  existingSecretPasswordKey: PAPERLESS_ADMIN_PASSWORD
  existingSecretEmailKey: PAPERLESS_ADMIN_MAIL

secretKey:
  existingSecret: paperless-secrets
  existingSecretKey: PAPERLESS_SECRET_KEY
```

## Upgrade

### Upgrading the Chart

```bash
# Update your custom values file as needed
helm upgrade my-paperless paperless-ngx/paperless-ngx -f values.yaml

# Or upgrade with inline values
helm upgrade my-paperless paperless-ngx/paperless-ngx \
  --set image.tag=3.0.5 \
  --set persistence.data.size=10Gi
```

### Database Migrations

Paperless-ngx runs database migrations automatically on startup. Check the logs after upgrading:

```bash
kubectl logs -l app.kubernetes.io/name=paperless-ngx -f
```

## Uninstall

### Removing the Release

```bash
helm uninstall my-paperless
```

This command removes all Kubernetes components created by the chart. To also delete persistent volumes:

```bash
# Note: This will delete all your document data!
kubectl delete pvc -l app.kubernetes.io/name=paperless-ngx
```

## Troubleshooting

### Common Issues

#### Pod CrashLoopBackOff

Check logs for database connection issues:

```bash
kubectl logs -l app.kubernetes.io/name=paperless-ngx
kubectl describe pod -l app.kubernetes.io/name=paperless-ngx
```

Common causes:
- Database credentials incorrect
- Redis unavailable
- Insufficient resources (check `kubectl describe pod` for OOMKilled)

#### Database Connection Errors

Ensure the database is accessible and credentials are correct. For CNPG:

```bash
kubectl get cluster
kubectl logs -l cnpg.io/instance_name=<release>-pg
```

For external database, verify connectivity from a pod:

```bash
kubectl run -it --rm debug --image=busybox --restart=Never -- sh
# In the pod:
nc -vz your-db-host 5432
```

#### Ingress 502 Errors

- Verify service is running: `kubectl get svc`
- Check pod readiness: `kubectl get pods -l app.kubernetes.io/name=paperless-ngx`
- Review ingress controller logs

#### PDF/Document Processing Failures

Check Gotenberg and Tika logs:

```bash
kubectl logs -l app.kubernetes.io/component=gotenberg
kubectl logs -l app.kubernetes.io/component=tika
```

Ensure they are enabled and running:

```bash
kubectl get deploy | grep -E "(gotenberg|tika)"
```

#### UI Shows "Loading..." Forever

Clear browser cache and check:
- `PAPERLESS_URL` is correctly set
- Ingress/CORS configuration
- Browser console for errors

### Resource Requirements

Recommended resources for production:
- Paperless-ngx: 1 CPU, 1Gi RAM (minimum), 2 CPU, 2Gi RAM (recommended)
- PostgreSQL (CNPG): 1 CPU, 1Gi RAM minimum
- Redis: 0.5 CPU, 512Mi RAM
- Gotenberg: 1 CPU, 512Mi RAM
- Tika: 1 CPU, 1Gi RAM

Adjust in `resources:` section of values.yaml.

## Contributing

Contributions are welcome! Here's how to contribute:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development

To test changes locally:

```bash
# Lint the chart
helm lint charts/paperless-ngx

# Dry-run installation
helm install test-chart ./charts/paperless-ngx --dry-run --debug

# Install to a cluster
helm install test-chart ./charts/paperless-ngx -n paperless --create-namespace
```

### Adding Features

When adding features:

1. Update `values.yaml` with new configuration options
2. Update `README.md` with documentation
3. Update template files as needed
4. Add/update tests

## License

This chart is licensed under the Apache License 2.0. See the [LICENSE](LICENSE) file for details.

Paperless-ngx itself is licensed under the MIT License.

## Additional Resources

- [Paperless-ngx Documentation](https://docs.paperless-ngx.com/)
- [Helm Documentation](https://helm.sh/docs/)
- [CloudNativePG Documentation](https://cloudnative-pg.io/documentation/)
