{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "paperless-ngx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "paperless-ngx.fullname" -}}
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
{{- define "paperless-ngx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "paperless-ngx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "paperless-ngx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the PostgreSQL resource
*/}}
{{- define "paperless-ngx.postgresql.host" -}}
{{- if .Values.postgresql.enabled }}
{{- if .Values.postgresql.host }}
{{- .Values.postgresql.host }}
{{- else }}
{{- printf "%s-postgresql" (include "paperless-ngx.fullname" .) }}
{{- end }}
{{- else }}
{{- .Values.postgresql.host | required "postgresql.host is required" }}
{{- end }}
{{- end }}

{{/*
Create the name of the Redis resource
*/}}
{{- define "paperless-ngx.redis.host" -}}
{{- if .Values.redis.enabled }}
{{- if .Values.redis.host }}
{{- .Values.redis.host }}
{{- else }}
{{- printf "%s-redis" (include "paperless-ngx.fullname" .) }}
{{- end }}
{{- else }}
{{- .Values.redis.host | required "redis.host is required" }}
{{- end }}
{{- end }}

{{/*
Generate the database connection string
*/}}
{{- define "paperless-ngx.database.url" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "postgresql://%s:%s@%s:%s/%s" .Values.postgresql.username (include "paperless-ngx.postgresql.password" .) (include "paperless-ngx.postgresql.host" .) (default "5432" .Values.postgresql.port) .Values.postgresql.database }}
{{- else }}
{{- required "postgresql settings are required when postgresql.enabled is false" .Values.postgresql.database }}
{{- end }}
{{- end }}

{{/*
Generate the database password from secret or default value
*/}}
{{- define "paperless-ngx.postgresql.password" -}}
{{- if .Values.postgresql.existingSecret }}
{{- printf "{{{{ index .Values.postgresql.existingSecret }}}}" }}
{{- else }}
{{- .Values.postgresql.password | required "postgresql.password is required" | b64enc }}
{{- end }}
{{- end }}

{{/*
Generate the redis password from secret or default value
*/}}
{{- define "paperless-ngx.redis.password" -}}
{{- if .Values.redis.existingSecret }}
{{- printf "{{{{ index .Values.redis.existingSecret }}}}" }}
{{- else }}
{{- .Values.redis.password | b64enc }}
{{- end }}
{{- end }}

{{/*
Generate the redis connection string
*/}}
{{- define "paperless-ngx.redis.url" -}}
{{- if .Values.redis.enabled }}
{{- $password := include "paperless-ngx.redis.password" . }}
{{- if $password }}
{{- printf "redis://:%s@%s:%s/0" $password (include "paperless-ngx.redis.host" .) (default "6379" .Values.redis.port) }}
{{- else }}
{{- printf "redis://%s:%s/0" (include "paperless-ngx.redis.host" .) (default "6379" .Values.redis.port) }}
{{- end }}
{{- else }}
{{- required "redis settings are required when redis.enabled is false" .Values.redis.host }}
{{- end }}
{{- end }}
