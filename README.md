# chart-idam-pr

This chart is intended for managing whitelisted redirect urls that are dynamic, e.g. PR style URLs in AKS: `https://cmc-citizen-frontend-pr-849.service.core-compute-preview.internal/receiver`.

The chart includes Kubernetes Jobs with Helm hooks that are run:
- post-install: whitelisted URL added to IDAM
- post-delete: whitelisted URL removed from IDAM

Both jobs use curl to send a PATCH request to IDAM:

```bash
curl -X PATCH \
  https://idam-api.aat.platform.hmcts.net/testing-support/services/Money%20Claims%20-%20Citizen \
    -H 'Accept: application/json' \
    -H 'Content-Type: application/json' \
    -d '[{
      "operation": "add",
      "field": "redirect_uri",
      "value": "https://cmc-citizen-frontend-pr-849.service.core-compute-preview.internal/receiver"
    }]'
```

## Example configuration

requirements.yaml
```yaml
dependencies:
  # other deps
  - name: idam-pr
    version: ~1.0.0
    repository: '@hmcts'
    tags:
      - idam-pr
```

values.template.yaml
```yaml
tags:
  idam-pr: true

# other services yaml

idam-pr:
  service:
    name: Money%20Claims%20-%20Citizen
    redirect_uri: https://${SERVICE_FQDN}/receiver
```
*Notes*: 
- idam-pr.service.name: as in example above, this needs to be curl safe and encoded correctly
- SERVICE_FQDN - is injected by Jenkins and values file templated before passing to Helm.

## Default values.yaml

```yaml
api:
  url: https://idam-api.aat.platform.hmcts.net

web_public:
  url: https://idam-web-public.aat.platform.hmcts.net

user:
  username: idamOwner@hmcts.net
  password: Ref0rmIsFun

service:
  name: test-public-service
  redirect_uri: http://localhost/oauth2/receiver

memoryRequests: "512Mi"
cpuRequests: "25m"
memoryLimits: "1024Mi"
cpuLimits: "2500m"
```