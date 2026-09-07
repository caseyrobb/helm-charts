{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "silo-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "silo-server.fullname" -}}
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
{{- define "silo-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "silo-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "silo-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the PostgreSQL resource
*/}}
{{- define "silo-server.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
{{- if .Values.postgresql.host }}
{{- .Values.postgresql.host }}
{{- else }}
{{- printf "%s-postgresql" (include "silo-server.fullname" .) }}
{{- end }}
{{- else }}
{{- .Values.postgresql.host | required "postgresql.host is required" }}
{{- end }}
{{- end }}

{{/*
Create the name of the Redis resource
*/}}
{{- define "silo-server.redis.host" -}}
{{- if .Values.redis.enabled }}
{{- if .Values.redis.host }}
{{- .Values.redis.host }}
{{- else }}
{{- printf "%s-redis" (include "silo-server.fullname" .) }}
{{- end }}
{{- else }}
{{- .Values.redis.host | required "redis.host is required" }}
{{- end }}
{{- end }}

{{/*
Generate the database connection string
*/}}
{{- define "silo-server.database.url" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.username (include "silo-server.postgresql.password" .) (include "silo-server.postgresql.host" .) (default "5432" .Values.postgresql.port) .Values.postgresql.database }}
{{- else }}
{{- printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.username .Values.postgresql.password (include "silo-server.postgresql.host" .) (default "5432" .Values.postgresql.port) .Values.postgresql.database }}
{{- end }}
{{- end }}

{{/*
Generate the database password from secret or default value
*/}}
{{- define "silo-server.postgresql.password" -}}
{{- if .Values.postgresql.existingSecret }}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (printf "%s" .Values.postgresql.existingSecret) }}
{{- if $secret }}
{{- index $secret "data" (default "postgresql-password" .Values.postgresql.existingSecretKey) }}
{{- else }}
{{- .Values.postgresql.password | required "postgresql.password is required" | b64enc }}
{{- end }}
{{- else }}
{{- .Values.postgresql.password | required "postgresql.password is required" | b64enc }}
{{- end }}
{{- end }}

{{/*
Generate the redis password from secret or default value
*/}}
{{- define "silo-server.redis.password" -}}
{{- if .Values.redis.existingSecret }}
{{- $secret := lookup "v1" "Secret" .Release.Namespace (printf "%s" .Values.redis.existingSecret) }}
{{- if $secret }}
{{- index $secret "data" (default "redis-password" .Values.redis.existingSecretKey) }}
{{- else }}
{{- .Values.redis.password | b64enc }}
{{- end }}
{{- else }}
{{- .Values.redis.password | b64enc }}
{{- end }}
{{- end }}

{{/*
Generate the redis connection string
*/}}
{{- define "silo-server.redis.url" -}}
{{- if .Values.redis.enabled }}
{{- $password := include "silo-server.redis.password" . }}
{{- if $password }}
{{- printf "redis://:%s@%s:%s/0" $password (include "silo-server.redis.host" .) (default "6379" .Values.redis.port) }}
{{- else }}
{{- printf "redis://%s:%s/0" (include "silo-server.redis.host" .) (default "6379" .Values.redis.port) }}
{{- end }}
{{- else }}
{{- printf "redis://%s:%s/0" (include "silo-server.redis.host" .) (default "6379" .Values.redis.port) }}
{{- end }}
{{- end }}

{{/*
Create common labels
*/}}
{{- define "silo-server.labels" -}}
helm.sh/chart: {{ include "silo-server.chart" . }}
{{ include "silo-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "silo-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "silo-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
