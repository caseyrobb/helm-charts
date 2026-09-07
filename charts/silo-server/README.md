# silo-server

[silo-server](https://github.com/Silo-Server/silo-server) is a self-hosted media server for films, series, audiobooks, ebooks, podcasts, and manga. It's compatible with the Jellyfin ecosystem and supports hardware-accelerated transcoding.

## Prerequisites

- Kubernetes 1.16+
- Helm 3.2+
- PostgreSQL 18 with pgvector extension
- Redis (for caching)
- PV provisioner support in the underlying infrastructure

## Installation

### Add the repository

```bash
helm repo add caseyrobb https://caseyrobb.github.io/helm-charts
helm repo update
```

### Install the chart

```bash
helm install my-silo caseyrobb/silo-server
```

### Install with custom values

```bash
helm install my-silo caseyrobb/silo-server \
  --set postgresql.password=secretpassword \
  --set config.silo_secret_key=mysecretkey
```

## Configuration

The following table lists the configurable parameters of the silo-server chart and their default values.

| Parameter | Description | Default |
|-----------|-------------|---------|
| `replicaCount` | Number of replicas | `1` |
| `image.repository` | Image repository | `ghcr.io/silo-server/silo-server` |
| `image.tag` | Image tag | `latest` |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` |
| `service.type` | Service type | `ClusterIP` |
| `service.ports.ui.port` | UI port | `8090` |
| `service.ports.jellyfin.port` | Jellyfin API port | `8096` |
| `postgresql.enabled` | Enable embedded PostgreSQL | `true` |
| `postgresql.host` | External PostgreSQL host | `""` |
| `postgresql.port` | PostgreSQL port | `5432` |
| `postgresql.database` | PostgreSQL database | `silo` |
| `postgresql.username` | PostgreSQL username | `silo` |
| `postgresql.password` | PostgreSQL password | `""` |
| `redis.enabled` | Enable embedded Redis | `true` |
| `redis.host` | External Redis host | `""` |
| `redis.port` | Redis port | `6379` |
| `persistence.size` | PVC size per volume | `100Gi` |
| `resources.limits.cpu` | CPU limit | `2000m` |
| `resources.limits.memory` | Memory limit | `4Gi` |
| `config.silo_url` | Silo URL | `http://localhost:8090` |
| `config.silo_secret_key` | Secret key | Generated randomly |
| `gpu.enabled` | Enable GPU transcoding | `false` |
| `gpu.device.intel` | Enable Intel GPU | `false` |

### Ingress Configuration

```yaml
ingress:
  enabled: true
  className: nginx
  hosts:
    - host: silo.example.com
      paths:
        - path: /
          pathType: Prefix
```

### Custom Storage Class

```yaml
persistence:
  storageClass: "premium-ssd"
  size: 200Gi
```

### External Database

```yaml
postgresql:
  enabled: false
  host: my-postgres.example.com
  port: 5432
  database: silo
  username: silo
  password: "mypassword"
  existingSecret: "silo-db-secret"
  existingSecretKey: "password"
```

### Hardware Transcoding (Intel QSV)

```yaml
config:
  silo_hwtranscode_intel: "true"
  silo_hwtranscode_vaapi: "/dev/dri/renderD128"

gpu:
  enabled: true
  device:
    intel: true
```

### Hardware Transcoding (NVIDIA)

```yaml
config:
  silo_hwtranscode_nvidia: "true"

gpu:
  enabled: true
  device:
    nvidia: true
```

### CORS Configuration

```yaml
config:
  silo_cors_origins: "https://my-app.com,https://another-app.com"
```

## Upgrade

```bash
helm upgrade my-silo caseyrobb/silo-server -f values.yaml
```

## Uninstall

```bash
helm uninstall my-silo
```

To delete the PVCs:

```bash
kubectl delete pvc -l app.kubernetes.io/name=silo-server
```

## Troubleshooting

### Pods not starting

Check logs:

```bash
kubectl logs -l app.kubernetes.io/name=silo-server
```

### Database connection issues

Verify PostgreSQL is running:

```bash
kubectl get pods -l app.kubernetes.io/name=postgresql
```

Check environment variables in the pod:

```bash
kubectl exec -it <pod-name> -- env | grep SILO_DB
```

### GPU not detected

Verify GPU devices are available on the node:

```bash
kubectl describe node | grep -i nvidia
```

For Intel QSV, ensure the node has `/dev/dri` devices:

```bash
ls /dev/dri/
```

### Memory issues

Increase resources:

```yaml
resources:
  limits:
    memory: 8Gi
  requests:
    memory: 2Gi
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request
