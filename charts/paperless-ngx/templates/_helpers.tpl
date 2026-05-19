{{/*
Expand the name of the chart.
*/}}
{{- define "paperless.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Fully qualified app name.
*/}}
{{- define "paperless.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "paperless.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "paperless.labels" -}}
helm.sh/chart: {{ include "paperless.chart" . }}
{{ include "paperless.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "paperless.selectorLabels" -}}
app.kubernetes.io/name: {{ include "paperless.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "paperless.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "paperless.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
Names of related resources.
*/}}
{{- define "paperless.secretName" -}}
{{ include "paperless.fullname" . }}-env
{{- end -}}

{{- define "paperless.configMapName" -}}
{{ include "paperless.fullname" . }}-config
{{- end -}}

{{- define "paperless.cnpg.clusterName" -}}
{{- default (printf "%s-pg" (include "paperless.fullname" .)) .Values.cnpg.clusterName -}}
{{- end -}}

{{/*
Name of the CNPG-generated app credentials secret. CNPG creates
`<cluster>-app` with `username` and `password` keys.
*/}}
{{- define "paperless.cnpg.appSecretName" -}}
{{- if .Values.cnpg.bootstrapSecret -}}
{{- .Values.cnpg.bootstrapSecret -}}
{{- else -}}
{{- printf "%s-app" (include "paperless.cnpg.clusterName" .) -}}
{{- end -}}
{{- end -}}

{{/*
Resolved DB host. CNPG exposes `<cluster>-rw` as the primary endpoint.
*/}}
{{- define "paperless.dbHost" -}}
{{- if .Values.cnpg.enabled -}}
{{- printf "%s-rw" (include "paperless.cnpg.clusterName" .) -}}
{{- else if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.host -}}
{{- end -}}
{{- end -}}

{{- define "paperless.dbPort" -}}
{{- if .Values.cnpg.enabled -}}
5432
{{- else if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.port | default 5432 -}}
{{- end -}}
{{- end -}}

{{- define "paperless.dbName" -}}
{{- if .Values.cnpg.enabled -}}
{{- .Values.cnpg.database -}}
{{- else if .Values.externalDatabase.enabled -}}
{{- .Values.externalDatabase.database -}}
{{- end -}}
{{- end -}}

{{- define "paperless.dbEngine" -}}
{{- if or .Values.cnpg.enabled (and .Values.externalDatabase.enabled (eq (.Values.database.engine | default "postgresql") "postgresql")) -}}
postgresql
{{- else if and .Values.externalDatabase.enabled (eq .Values.database.engine "mariadb") -}}
mariadb
{{- else -}}
sqlite
{{- end -}}
{{- end -}}

{{/*
Resolved Redis URL. Returns the in-cluster Bitnami service when enabled,
otherwise the user-supplied URL (which may also come from existingSecret).
*/}}
{{- define "paperless.redisUrl" -}}
{{- if .Values.redis.enabled -}}
{{- printf "redis://%s-redis-master:6379" .Release.Name -}}
{{- else if .Values.externalRedis.enabled -}}
{{- .Values.externalRedis.url -}}
{{- end -}}
{{- end -}}

{{- define "paperless.gotenberg.fullname" -}}
{{ include "paperless.fullname" . }}-gotenberg
{{- end -}}

{{- define "paperless.tika.fullname" -}}
{{ include "paperless.fullname" . }}-tika
{{- end -}}
