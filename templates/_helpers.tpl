{{/*
Expand the name of the chart.
*/}}
{{- define "m3music.name" -}}
{{- $global := default dict .Values.global }}
{{- default "m3-music" $global.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "m3music.fullname" -}}
{{- $global := default dict .Values.global }}
{{- if $global.fullnameOverride }}
{{- $global.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "m3-music" $global.nameOverride }}
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
{{- define "m3music.chart" -}}
{{- printf "%s-%s" (include "m3music.name" .) .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "m3music.labels" -}}
helm.sh/chart: {{ include "m3music.chart" . }}
{{ include "m3music.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "m3music.selectorLabels" -}}
app.kubernetes.io/name: {{ include "m3music.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "m3music.serviceAccountName" -}}
{{- $serviceAccount := default dict .Values.serviceAccount }}
{{- $global := default dict .Values.global }}
{{- $globalServiceAccount := default dict $global.serviceAccount }}
{{- $name := coalesce $globalServiceAccount.name $serviceAccount.name }}
{{- if $serviceAccount.create }}
{{- default (include "m3music.fullname" .) $name }}
{{- else }}
{{- default "default" $name }}
{{- end }}
{{- end }}

{{/*
Shared ConfigMap name for frontend and backend runtime env.
*/}}
{{- define "m3music.configMapName" -}}
{{- printf "%s-env" (include "m3music.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Shared Secret name for backend runtime env.
*/}}
{{- define "m3music.secretName" -}}
{{- printf "%s-secrets" (include "m3music.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Backend fullname used by backend subchart templates
*/}}
{{- define "m3music.backend.fullname" -}}
{{- printf "%s-backend" (include "m3music.fullname" .) }}
{{- end }}

{{/*
Frontend fullname used by frontend subchart templates
*/}}
{{- define "m3music.frontend.fullname" -}}
{{- printf "%s-frontend" (include "m3music.fullname" .) }}
{{- end }}


