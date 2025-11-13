{{- define "hp-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{- define "hp-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "hp-app.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end }}

{{- define "hp-app.labels" -}}
app.kubernetes.io/name: {{ include "hp-app.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "hp-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "hp-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "hp-app.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "hp-app.fullname" .) .Values.serviceAccount.name -}}
{{- else }}
{{- default "default" .Values.serviceAccount.name -}}
{{- end }}
{{- end }}

{{- define "hp-app.image" -}}
{{- $global := .Values.global.image -}}
{{- $img := .image | default dict -}}
{{- $repository := default $global.repository $img.repository -}}
{{- $tag := default $global.tag $img.tag -}}
{{- $pullPolicy := default $global.pullPolicy $img.pullPolicy -}}
repository: {{ $repository | quote }}
tag: {{ $tag | quote }}
pullPolicy: {{ $pullPolicy | quote }}
{{- end }}
