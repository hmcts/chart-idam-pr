#!/usr/bin/env sh
set -e
{{ range $key, $value := .Values.redirect_uris }}
for redirect_uri in {{ join " " $value }} 
do
echo "Registering new redirect URI for service {{ $key }}: ${redirect_uri} using {{ $.Values.api.url }}"

curl -X PATCH \
  {{ $.Values.api.url }}/testing-support/services/{{ $key | urlquery | replace "+" "%20" }} \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '[ {
	"operation": "add",
	"field": "redirect_uri",
	"value": "'${redirect_uri}'"
}
]'
done
{{ end }}
