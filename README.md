# helm-charts

A collection of Helm charts maintained by [@caseyrobb](https://github.com/caseyrobb), published as a Helm repository via GitHub Pages.

## Usage

Add the repository:

```bash
helm repo add caseyrobb https://caseyrobb.github.io/helm-charts
helm repo update
```

Search and install:

```bash
helm search repo caseyrobb
helm install my-release caseyrobb/<chart-name>
```

## Charts

| Chart | Description |
| --- | --- |
| [paperless-ngx](charts/paperless-ngx) | Paperless-ngx document management system, with optional CloudNativePG and Bitnami Redis dependencies. |

## Development

Charts live under [`charts/`](charts/). Each chart is independently versioned via its `Chart.yaml`.

Lint and template a chart locally:

```bash
helm dependency update charts/<chart-name>
helm lint charts/<chart-name>
helm template charts/<chart-name>
```

Run the same checks CI runs:

```bash
ct lint --config .github/ct.yaml
```

### Releasing

Releases are automated. Bump the `version` in a chart's `Chart.yaml` and merge to `master`; the release workflow packages the chart, creates a GitHub Release, and updates the `gh-pages` index so the new version is served from the Helm repo URL above.

## License

[MIT](LICENSE)
