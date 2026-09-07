# Silo Server Helm Chart

A Helm chart for Silo Server - a self-hosted media server for films, series, audiobooks, ebooks, podcasts, and manga.

## Prerequisites

- Kubernetes cluster (1.21+)
- Helm 3.8+
- PostgreSQL (external or via subchart)
- Redis (external or via subchart)

## Installation

### Default Installation

```bash
helm install silo-server ./charts/silo-server --create-namespace --namespace silo
```

### Installation with Custom Values

```bash
helm install silo-server ./charts/silo-server \
  --namespace silo \
  --create-namespace \
  -f values.custom.yaml
```

### Installation from Remote Repository

```bash
helm repo add silo-server https://silo-server.github.io/helm-charts
helm install silo-server silo-server/silo-server --namespace silo --create-namespace
```

## Configuration

The following table lists the configurable parameters of the Silo Server chart and their default values.

| Parameter | Description | Default | Notes |
|-----------|-------------|---------|-------|
| **Global Parameters** | | | |
| `replicaCount` | Number of Silo Server replicas | `1` | |
| `image.repository` | Silo Server image repository | `ghcr.io/silo-server/silo-server` | |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | |
| `image.tag` | Silo Server image tag | `"latest"` | |
| `imagePullSecrets` | Reference to secrets for private registry | `[]` | Array of secret names |
| `nameOverride` | Chart name override | `""` | |
| `fullnameOverride` | Full name override | `""` | |
| **Service Account** | | | |
| `serviceAccount.create` | Whether to create a service account | `true` | |
| `serviceAccount.annotations` | Annotations to add to the service account | `{}` | |
| `serviceAccount.name` | Service account name | `""` | Use default if empty |
| **Pod Configuration** | | | |
| `podAnnotations` | Annotations to add to pods | `{}` | |
| `podSecurityContext` | Security context for pod | `{}` | |
| `securityContext` | Security context for container | `{}` | |
| **Service Configuration** | | | |
| `service.type` | Kubernetes service type | `ClusterIP` | ClusterIP, NodePort, LoadBalancer |
| `service.ports.ui.port` | UI service port | `8090` | |
| `service.ports.ui.targetPort` | UI container port | `8090` | |
| `service.ports.ui.protocol` | UI port protocol | `TCP` | |
| `service.ports.jellyfin.port` | Jellyfin API service port | `8096` | |
| `service.ports.jellyfin.targetPort` | Jellyfin API container port | `8096` | |
| `service.ports.jellyfin.protocol` | Jellyfin API port protocol | `TCP` | |
| **Resource Configuration** | | | |
| `resources.limits.cpu` | CPU limit | `2000m` | |
| `resources.limits.memory` | Memory limit | `4Gi` | |
| `resources.requests.cpu` | CPU request | `500m` | |
| `resources.requests.memory` | Memory request | `512Mi` | |
| **Autoscaling** | | | |
| `autoscaling.enabled` | Enable Horizontal Pod Autoscaler | `false` | |
| `autoscaling.minReplicas` | Minimum replicas | `1` | |
| `autoscaling.maxReplicas` | Maximum replicas | `100` | |
| `autoscaling.targetCPUUtilizationPercentage` | Target CPU utilization | `80` | |
| **Node Configuration** | | | |
| `nodeSelector` | Node labels for pod assignment | `{}` | |
| `tolerations` | Tolerations for pod assignment | `[]` | |
| `affinity` | Affinity rules for pod assignment | `{}` | |
| **PostgreSQL Configuration** | | | |
| `postgresql.enabled` | Enable PostgreSQL subchart | `true` | |
| `postgresql.name` | PostgreSQL name | `postgresql` | |
| `postgresql.host` | PostgreSQL host | `""` | Empty uses subchart |
| `postgresql.port` | PostgreSQL port | `5432` | |
| `postgresql.database` | PostgreSQL database name | `silo` | |
| `postgresql.username` | PostgreSQL username | `silo` | |
| `postgresql.password` | PostgreSQL password | `""` | Empty generates secret |
| `postgresql.existingSecret` | Existing secret name | `""` | Use existing secret |
| `postgresql.existingSecretKey` | Secret key for password | `postgresql-password` | |
| **Redis Configuration** | | | |
| `redis.enabled` | Enable Redis subchart | `true` | |
| `redis.name` | Redis name | `redis` | |
| `redis.host` | Redis host | `""` | Empty uses subchart |
| `redis.port` | Redis port | `6379` | |
| `redis.password` | Redis password | `""` | Empty generates secret |
| `redis.existingSecret` | Existing secret name | `""` | Use existing secret |
| `redis.existingSecretKey` | Secret key for password | `redis-password` | |
| **Persistence Configuration** | | | |
| `persistence.enabled` | Enable persistence | `true` | |
| `persistence.storageClass` | Storage class for PVCs | `""` | Empty uses default |
| `persistence.accessModes` | PVC access modes | `["ReadWriteOnce"]` | |
| `persistence.size` | PVC size | `100Gi` | |
| `persistence.existingClaim` | Existing PVC name | `""` | Use existing claim |
| `persistence.transcodeSubPath` | Transcode subpath | `transcode` | |
| `persistence.pluginsSubPath` | Plugins subpath | `plugins` | |
| `persistence.catalogSeedsSubPath` | Catalog seeds subpath | `catalog-seeds` | |
| `persistence.mediaSubPath` | Media subpath | `media` | |
| **Silo Server Configuration** | | | |
| `config.silo_url` | Base URL for Silo Server | `"http://localhost:8090"` | |
| `config.silo_host` | Host to bind to | `"0.0.0.0"` | |
| `config.silo_port` | UI port | `8090` | |
| `config.silo_media_port` | Jellyfin API port | `8096` | |
| `config.silo_listen` | Listen address | `"0.0.0.0:8090"` | |
| `config.silo_transcode_dir` | Transcode directory | `/tmp/transcode` | |
| `config.silo_plugins_dir` | Plugins directory | `/app/plugins` | |
| `config.silo_catalog_seeds_dir` | Catalog seeds directory | `/app/catalog-seeds` | |
| `config.silo_media_dir` | Media directory | `/media` | |
| `config.silo_db_host` | Database host | `""` | Overrides postgresql settings |
| `config.silo_db_port` | Database port | `""` | |
| `config.silo_db_name` | Database name | `""` | |
| `config.silo_db_user` | Database user | `""` | |
| `config.silo_db_pass` | Database password | `""` | |
| `config.silo_redis_host` | Redis host | `""` | Overrides redis settings |
| `config.silo_redis_port` | Redis port | `""` | |
| `config.silo_redis_pass` | Redis password | `""` | |
| `config.silo_secret_key` | Secret key for signing | `""` | Empty generates random |
| `config.silo_cors_origins` | Allowed CORS origins | `"*"` | Space-separated list |
| `config.silo_trusted_proxy` | Trusted proxy CIDR | `""` | e.g., `10.0.0.0/8` |
| `config.silo_hwtranscode_intel` | Enable Intel QSV | `"true"` | |
| `config.silo_hwtranscode_nvidia` | Enable NVIDIA NVENC | `"false"` | |
| `config.silo_hwtranscode_arm` | Enable ARM VPU | `"false"` | |
| `config.silo_hwtranscode_vaapi` | VAAPI render device | `/dev/dri/renderD128` | |
| `config.silo_log_level` | Log level | `"info"` | debug, info, warn, error |
| **GPU Configuration** | | | |
| `gpu.enabled` | Enable GPU support | `false` | |
| `gpu.device.intel` | Enable Intel GPU | `false` | Requires node selector |
| `gpu.device.nvidia` | Enable NVIDIA GPU | `false` | Requires NVIDIA plugin |
| `gpu.device.arm` | Enable ARM GPU | `false` | |

## Upgrading

### From an Older Version

```bash
# Update helm repo
helm repo update

# Upgrade the release
helm upgrade silo-server ./charts/silo-server --namespace silo
```

### Using a Values File

```bash
helm upgrade silo-server ./charts/silo-server \
  --namespace silo \
  -f values.custom.yaml
```

## Uninstall

```bash
helm uninstall silo-server --namespace silo
```

> **Note**: This will remove the deployment but will NOT delete the PVCs. To delete PVCs:
> ```bash
> kubectl delete pvc -l app=silo-server --namespace silo
> ```

## Configuration Examples

### Enable Ingress

```yaml
service:
  type: ClusterIP

ingress:
  enabled: true
  className: nginx
  hosts:
    - host: silo.example.com
      paths:
        - path: /
          pathType: Prefix
```

### Configure PostgreSQL and Redis with Existing Secrets

```yaml
postgresql:
  enabled: false
  host: my-postgres.example.com
  port: 5432
  database: silo
  username: silo
  existingSecret: postgres-secret
  existingSecretKey: password

redis:
  enabled: false
  host: my-redis.example.com
  port: 6379
  existingSecret: redis-secret
  existingSecretKey: password
```

### Custom Storage Class for PVCs

```yaml
persistence:
  enabled: true
  storageClass: "ssd-storage"
  accessModes:
    - ReadWriteOnce
  size: 200Gi
```

### Enable Hardware Transcoding (Intel QSV)

```yaml
config:
  silo_hwtranscode_intel: "true"
  silo_hwtranscode_nvidia: "false"

gpu:
  enabled: true
  device:
    intel: true
    nvidia: false
    arm: false
```

### Enable Hardware Transcoding (NVIDIA)

```yaml
config:
  silo_hwtranscode_intel: "false"
  silo_hwtranscode_nvidia: "true"

gpu:
  enabled: true
  device:
    intel: false
    nvidia: true
    arm: false
```

### Enable Autoscaling

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
```

### Configure CORS and Trusted Proxy

```yaml
config:
  silo_cors_origins: "https://example.com https://app.example.com"
  silo_trusted_proxy: "10.0.0.0/8 172.16.0.0/12"
```

## Troubleshooting

### Pod Won't Start

Check logs:
```bash
kubectl logs <pod-name> --namespace silo
```

Describe pod for events:
```bash
kubectl describe pod <pod-name> --namespace silo
```

### Database Connection Issues

Verify PostgreSQL and Redis are accessible:
```bash
kubectl run -it --rm debug --image=busybox --restart=Never --namespace silo -- sh
```

Then test connectivity:
```bash
# Test PostgreSQL
nc -zv <postgres-host> 5432

# Test Redis
nc -zv <redis-host> 6379
```

### PVC Issues

Check PVC status:
```bash
kubectl get pvc --namespace silo
kubectl describe pvc <pvc-name> --namespace silo
```

### Resource Constraints

If pods are OOMKilled, increase memory limits:
```yaml
resources:
  limits:
    memory: 8Gi
  requests:
    memory: 1Gi
```

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Helm best practices
- Update this README for any configuration changes
- Test changes with `helm lint` and `helm template`
- Use semantic versioning for chart versions
