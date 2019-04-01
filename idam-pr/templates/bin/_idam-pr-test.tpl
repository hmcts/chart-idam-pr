#!/usr/bin/env sh

echo "================================================================"
echo "Getting the csrf token"
echo "================================================================"

getLoginPage=$(curl -s -v -c cookies.txt -b cookies.txt '{{ .Values.web_public.url }}/login?redirect_uri={{ .Values.service.redirect_uri }}&client_id={{ .Values.service.name }}' 2<&1)

csrf=$(cat cookies.txt | grep -oE 'TOKEN.*' | grep -oE '[^TOKEN\t]+' | tr -d '[:space:]' 2<&1)

echo "================================================================"
echo "found token $csrf"
echo "================================================================"

response=$(curl -s -v -c cookies.txt -b cookies.txt -d "_csrf=$csrf&client_id={{ .Values.service.name }}&username={{ .Values.user.username }}&password={{ .Values.user.password }}&redirect_uri={{ .Values.service.redirect_uri }}&state=12345&selfRegistrationEnabled=true" '{{ .Values.web_public.url }}/login' 2<&1)

httpCode=$(echo $response | grep -Eo 302)

if [ $httpCode  = 302 ]; then
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