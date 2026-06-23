#!/usr/bin/env bash
#
# install-flow-plugins.sh
# -----------------------
# Installs the Kestra plugins required by the flows in resources/flows/ into the
# RUNNING kestra container, then restarts it so the plugins are loaded.
#
# Why this exists: `terraform plan` renders flow YAML locally and never checks the
# server, so it passes even when a flow references a task/trigger type the instance
# doesn't have. `terraform apply` (and the /flows/validate API) then fails with
# "Invalid type: ...". This installs the missing plugins so apply succeeds.
#
# Mechanism: the EE versioned-plugins API (/api/v1/cluster/versioned-plugins/install)
# is the cleanest path, but on this instance it returns 403 for the basic-auth user
# (not a cluster Super Admin / plugin management not enabled). So we install via the
# in-container CLI, which downloads the jars from Maven Central into /app/plugins.
#
# Notes / caveats:
#   * /app/plugins is NOT a mounted volume here, so installs survive `docker compose
#     restart` but are LOST on container recreate (`down`/`up`, image change). For a
#     durable setup, mount `./plugins:/app/plugins` or bake the jars into the image.
#   * Versions: the instance is 2.0.0-rc2, but the matching rc plugin jars live on the
#     authenticated registry.kestra.io (HTTP 401 without license creds). LATEST pulls
#     compatible stable jars from Maven Central instead.
#
# Usage:  ./scripts/install-flow-plugins.sh
set -euo pipefail

cd "$(dirname "$0")/.."                       # repo root

SERVICE="kestra"
PLUGINS_PATH="/app/plugins"
KESTRA_CP="/app/kestra"                        # classpath archive run via java -cp
KESTRA_MAIN="io.kestra.ee.cli.Kestra"
CONFIG="/app/application.yaml"

# Plugins required by the flows (groupId:artifactId). Version pinned to LATEST.
PLUGINS=(
  "io.kestra.plugin:plugin-script-shell"   # scripts.shell.Commands
  "io.kestra.plugin:plugin-script-python"  # scripts.python.Script
  "io.kestra.plugin:plugin-aws"            # aws.s3.Upload / aws.cli.AwsCLI
  "io.kestra.plugin:plugin-jdbc-duckdb"    # jdbc.duckdb.Query/Queries
  "io.kestra.plugin:plugin-jdbc-sqlite"    # jdbc.sqlite.Queries
  "io.kestra.plugin:plugin-slack"          # slack.app.core.Trigger
  "io.kestra.plugin:plugin-ai"             # ai.agent.AIAgent
  "io.kestra.plugin:plugin-datagen"        # datagen.core.Trigger (exercice2_parent)
)

run_cli() { docker compose exec -T "$SERVICE" java -cp "$KESTRA_CP" "$KESTRA_MAIN" "$@"; }

echo "Kestra version in container:"
run_cli --version 2>/dev/null | tail -1 || true
echo

for p in "${PLUGINS[@]}"; do
  echo ">> installing ${p}:LATEST"
  if run_cli plugins install -c "$CONFIG" -p "$PLUGINS_PATH" "${p}:LATEST" 2>&1 \
       | grep -iE 'installed successfully|Successfully installed|Failed|could not|absent'; then
    :
  else
    echo "   (no status line captured — check manually)"
  fi
  echo
done

echo "Installed jars in ${PLUGINS_PATH}:"
docker compose exec -T "$SERVICE" sh -c "ls -1 ${PLUGINS_PATH}/*.jar 2>/dev/null" || true
echo

echo "Restarting ${SERVICE} to load plugins..."
docker compose restart "$SERVICE"
echo "Waiting for the API to come back up..."
for i in $(seq 1 60); do
  code=$(curl -s -o /dev/null -w '%{http_code}' http://localhost:8080/api/v1/main/flows || true)
  if [ "$code" = "200" ] || [ "$code" = "401" ] || [ "$code" = "403" ]; then
    echo "API responding (HTTP $code) after ~${i}0s"; break
  fi
  sleep 10
done
echo "Done. Re-run the validate loop to confirm all flows are OK."
