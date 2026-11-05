#!/usr/bin/env bash
set -euo pipefail
WAR_SOURCE="${1:?Usage: deploy-enterprise-portal /home/deploy/staging/enterprise-portal.war}"
APP="enterprise-portal"
WEBAPPS="/opt/tomcat/webapps"
BACKUPS="/opt/deploy-backups"
TARGET="${WEBAPPS}/${APP}.war"
EXPLODED="${WEBAPPS}/${APP}"
STAMP="$(date -u +%Y%m%dT%H%M%SZ)"
BACKUP="${BACKUPS}/${APP}-${STAMP}.war"
TMP="${TARGET}.new"
[[ -f "$WAR_SOURCE" ]] || { echo "WAR not found: $WAR_SOURCE" >&2; exit 1; }
mkdir -p "$BACKUPS"
[[ ! -f "$TARGET" ]] || cp -p "$TARGET" "$BACKUP"
trap 'rm -f "$TMP"' EXIT
install -o tomcat -g tomcat -m 0640 "$WAR_SOURCE" "$TMP"
mv -f "$TMP" "$TARGET"
healthy=0
for attempt in $(seq 1 30); do
  if curl --fail --silent "http://127.0.0.1:8080/${APP}/health" >/dev/null; then healthy=1; break; fi
  sleep 3
done
if [[ "$healthy" -eq 1 ]]; then echo "Deployment successful: $APP"; exit 0; fi
echo "Health check failed; rolling back." >&2
if [[ -f "$BACKUP" ]]; then
  systemctl stop tomcat
  install -o tomcat -g tomcat -m 0640 "$BACKUP" "$TARGET"
  rm -rf "$EXPLODED"
  systemctl start tomcat
else
  systemctl stop tomcat
  rm -f "$TARGET"; rm -rf "$EXPLODED"
  systemctl start tomcat
fi
exit 1
