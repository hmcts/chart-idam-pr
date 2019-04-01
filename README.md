# chart-idam-pr

## Example configuration

The `SERVICE_FQDN` needs to be provided

ci-values.yaml
```yaml
api:
  url: https://idam-api.aat.plaform.hmcts.net

web_public:
  url: https://idam-web-public.aat.platform.hmcts.net

user:
  username: some_user
  password: some_password

service:
  name: <your-service-name>
  redirect_uri: http://${SERVICE_FQDN}/<your-redirect-endpoint>
```

```helm install -f ci-values.yaml --dry-run --debug ./idam-pr/```
