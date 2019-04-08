#!/usr/bin/env sh

testUsername="james.bond$(($(date +%s%N)/1000))@hmcts.net"
testPassword="Agent007"

echo "================================================================"
echo "Creating a new test user $testUsername"
echo "================================================================"
curl -s -X POST {{ .Values.api.url }}/testing-support/accounts \
  -H 'Content-Type: application/json' \
  -d '{"email": "'$testUsername'", "forename": "James", "surname": "Bond", "password": "'$testPassword'", "roles": [{"code": "citizen"}]}'

echo "================================================================"
echo "Getting the csrf token"
echo "================================================================"

getLoginPage=$(curl -s -v -c cookies.txt -b cookies.txt '{{ .Values.web_public.url }}/login?redirect_uri={{ .Values.service.redirect_uri }}&client_id={{ .Values.service.name }}' 2<&1)

csrf=$(cat cookies.txt | grep -oE 'TOKEN.*' | grep -oE '[^TOKEN\t]+' | tr -d '[:space:]' 2<&1)

echo "================================================================"
echo "found token $csrf"
echo "================================================================"

response=$(curl -s -i -c cookies.txt -b cookies.txt -d "_csrf=$csrf&client_id={{ .Values.service.name }}&username=$testUsername&password=$testPassword&redirect_uri={{ .Values.service.redirect_uri }}&state=12345&selfRegistrationEnabled=true" '{{ .Values.web_public.url }}/login' 2<&1)
httpCode=$(echo $response | grep -Eo 302)

echo "================================================================"
echo "Deleting the test user"
echo "================================================================"
curl -s -X DELETE "{{ .Values.api.url }}/testing-support/accounts/$testUsername"

if [ "$httpCode"  == "302" ]; then
  echo "================================================================"
  echo "HTTP response code was $httpCode"
  echo "================================================================"
  echo "LOGIN SUCCEEDED WITH PROVIDED CLIENT_ID AND REDIRECT_URI"
else
  echo "================================================================"
  echo "Was incorrectly redirected to login page"
  echo "================================================================"
  echo "LOGIN FAILED WITH SUPPLIED DETAILS"
  exit 1
fi