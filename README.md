# chart-idam-pr

Redirect URLs are a critical part of the OAuth2 authorization flow that IDAM implements and Reform Services use to log 
users into their applications. After a user successfully authenticates with IDAM, IDAM then redirects the user back to 
the originating application with either an authorization code in the URL. Because the redirect URL contains sensitive 
information, it is critical that IDAM does not redirect the user to arbitrary locations.

The best way to ensure the user is only directed to appropriate locations is to require IDAM admins and developers to 
register one or more redirect URLs for their services. Most services are set up with the correct list of URLs in IDAM 
Admin Console by the IDAM system owner. This works well for Production, however makes developers lives hard if they 
want to use application URLs that are not static (e.g. `https://moneyclaims.aat.platform.hmcts.net/receiver`). 

This chart is intended for managing whitelisted redirect URLs that are dynamic, e.g. PR style URLs in AKS: 
`https://cmc-citizen-frontend-pr-849.service.core-compute-preview.internal/receiver`.

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

values.preview.yaml
```yaml
tags:
  idam-pr: true

# other services yaml

idam-pr:
  service:
    name: Money Claims - Citizen
    redirect_uri: https://${SERVICE_FQDN}/receiver
```
*Notes*: 
- idam-pr.service.name: name of the service as configured in IDAM. It is unique per service per environment and will 
match the label your service appears with in IDAM Admin Console. If you are not sure what it  needs to be set to, 
please contact IDAM team at #sidam-team.
- idam-pr.service.redirect_uri: this is the application callback URL where IDAM will send back the authentication code 
- SERVICE_FQDN - is injected by Jenkins and values file templated before passing to Helm.

## Default values.yaml

```yaml
api:
  url: https://idam-api.aat.platform.hmcts.net

web_public:
  url: https://idam-web-public.aat.platform.hmcts.net

service:
  name: test-public-service
  redirect_uri: http://localhost/oauth2/receiver

memoryRequests: "512Mi"
cpuRequests: "25m"
memoryLimits: "1024Mi"
cpuLimits: "2500m"
```
