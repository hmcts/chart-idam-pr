#!/usr/bin/env sh
set -e

echo "Removing redirect URI for service {{ .Values.service.name }}: {{ .Values.service.redirect_uri }} using {{ .Values.api.url }}"

curl -X PATCH \
  {{ .Values.api.url }}/testing-support/services/{{ .Values.service.name }} \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '[ {
	"operation": "delete",
	"field": "redirect_uri",
	"value": "{{ .Values.service.redirect_uri }}"
}
]'