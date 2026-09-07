# Helm Charts

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Helm charts repository hosted at [github.com/caseyrobb/helm-charts](https://github.com/caseyrobb/helm-charts).

## Description

This repository contains Helm charts for deploying applications and services to Kubernetes clusters. Each chart is designed to be configurable and production-ready.

## Installation

Add this repository to your Helm instance:

```bash
helm repo add caseyrobb https://caseyrobb.github.io/helm-charts
helm repo update
```

Install a chart from this repository:

```bash
helm install <release-name> caseyrobb/<chart-name>
```

## Available Charts

| Chart Name | Description | Version | Status |
|------------|-------------|---------|--------|
| [paperless-ngx](https://github.com/paperless-ngx/paperless-ngx) | A document management system that transforms your physical documents into a searchable online archive | 0.3.2 | Ready |
| [patchmon](https://github.com/patchmon/patchmon) | Enterprise-grade Linux patch & server management platform with RDP support | 0.1.0 | Ready |
| [silo-server](https://github.com/Silo-Server/silo-server) | A self-hosted media server for films, series, audiobooks, ebooks, podcasts, and manga | 0.4.1 | Ready |

## Contributing

Contributions are welcome! To add a new chart to this repository:

1. Fork the repository
2. Create a new branch for your chart (`git checkout -b feature/your-chart-name`)
3. Create your chart directory under `/charts/` with proper Helm chart structure
4. Ensure your chart follows Helm best practices and naming conventions
5. Update the `README.md` table with your chart information
6. Ensure version numbers follow [SemVer](https://semver.org/) guidelines
7. Test your chart locally with `helm lint` and `helm template`
8. Submit a pull request

### Chart Requirements

- Charts must follow the [Helm best practices](https://helm.sh/docs/chart_best_practices/)
- Version numbers should follow Semantic Versioning (MAJOR.MINOR.PATCH)
- Charts should be well-documented with clear values.yml descriptions
- No source code is included in this repository - charts reference external container images

## License

This repository is licensed under the [MIT License](LICENSE).
