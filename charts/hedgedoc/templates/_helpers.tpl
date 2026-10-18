{{/*
Expand the name of the chart.
*/}}
{{- define "hedgedoc.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "hedgedoc.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "hedgedoc.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "hedgedoc.labels" -}}
helm.sh/chart: {{ include "hedgedoc.chart" . }}
{{ include "hedgedoc.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "hedgedoc.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hedgedoc.name" . }}
app.kubernetes.io/instance: {{ include "hedgedoc.fullname" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "hedgedoc.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hedgedoc.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the CNPG Cluster CR. Defaults to "<fullname>-pg" when cnpg.clusterName is empty.
*/}}
{{- define "hedgedoc.cnpg.clusterName" -}}
{{- default (printf "%s-pg" (include "hedgedoc.fullname" .)) .Values.cnpg.clusterName -}}
{{- end }}

{{/*
Name of the CNPG-generated app credentials secret. CNPG creates
`<cluster>-app` with `username` and `password` keys.
*/}}
{{- define "hedgedoc.cnpg.appSecretName" -}}
{{- printf "%s-app" (include "hedgedoc.cnpg.clusterName" .) -}}
{{- end }}

{{/*
Database connection parameters, from CNPG when enabled else externalDatabase.
*/}}
{{- define "hedgedoc.dbHost" -}}
{{- if .Values.cnpg.enabled -}}
{{- printf "%s-rw" (include "hedgedoc.cnpg.clusterName" .) -}}
{{- else -}}
{{- required "externalDatabase.host is required when cnpg.enabled=false" .Values.externalDatabase.host -}}
{{- end -}}
{{- end }}

{{- define "hedgedoc.dbPort" -}}
{{- if .Values.cnpg.enabled -}}5432{{- else -}}{{- .Values.externalDatabase.port -}}{{- end -}}
{{- end }}

{{- define "hedgedoc.dbName" -}}
{{- if .Values.cnpg.enabled -}}{{- .Values.cnpg.database -}}{{- else -}}{{- .Values.externalDatabase.database -}}{{- end -}}
{{- end }}

{{- define "hedgedoc.dbUser" -}}
{{- if .Values.cnpg.enabled -}}{{- .Values.cnpg.owner -}}{{- else -}}{{- required "externalDatabase.username is required when cnpg.enabled=false" .Values.externalDatabase.username -}}{{- end -}}
{{- end }}
