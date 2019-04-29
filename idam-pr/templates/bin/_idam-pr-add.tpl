#!/usr/bin/env sh
set -e

for redirect_uri in $@ 
do
echo "Registering new redirect URI for service {{ .Values.service.name }}: ${redirect_uri} using {{ .Values.api.url }}"

curl -X PATCH \
  {{ .Values.api.url }}/testing-support/services/{{ .Values.service.name | urlquery | replace "+" "%20" }} \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '[ {
	"operation": "add",
	"field": "redirect_uri",
	"value": "${redirect_uri}"
}
]'
done