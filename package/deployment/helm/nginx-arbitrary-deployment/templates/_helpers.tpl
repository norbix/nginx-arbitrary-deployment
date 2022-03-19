{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-arbitrary-deployment.name" -}}
{{- default .Chart.Name .Values.frontend.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "nginx-arbitrary-deployment.frontend.name" -}}
{{- default .Chart.Name .Values.frontend.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx-arbitrary-deployment.fullname" -}}
{{- if .Values.frontend.fullnameOverride }}
{{- .Values.frontend.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.frontend.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "nginx-arbitrary-deployment.frontend.fullname" -}}
{{- if .Values.frontend.fullnameOverride }}
{{- .Values.frontend.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.frontend.nameOverride }}
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
{{- define "nginx-arbitrary-deployment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Common labels
*/}}
{{- define "nginx-arbitrary-deployment.labels" -}}
helm.sh/chart: {{ include "nginx-arbitrary-deployment.chart" . }}
{{ include "nginx-arbitrary-deployment.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "nginx-arbitrary-deployment.frontend.labels" -}}
helm.sh/chart: {{ include "nginx-arbitrary-deployment.chart" . }}
{{ include "nginx-arbitrary-deployment.frontend.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "nginx-arbitrary-deployment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-arbitrary-deployment.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "nginx-arbitrary-deployment.frontend.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-arbitrary-deployment.frontend.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}


{{/*
Create the name of the service account to use
*/}}
{{- define "nginx-arbitrary-deployment.serviceAccountName" -}}
{{- if .Values.frontend.serviceAccount.create }}
{{- default (include "nginx-arbitrary-deployment.fullname" .) .Values.frontend.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.frontend.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Create system url
*/}}
{{- define "nginx-arbitrary-deployment.baseUrl" -}}
{{- if .Values.global.subdomain.enabled -}}
    {{- if .Values.global.subdomain.override -}}
        {{ .Values.global.subdomain.override }}.{{ .Values.global.domain }}
    {{- else -}}
        {{ .Release.Namespace }}.{{ .Values.global.domain }}
    {{- end -}}
{{- else -}}
    {{ .Values.global.domain }}
{{- end -}}
{{- end -}}