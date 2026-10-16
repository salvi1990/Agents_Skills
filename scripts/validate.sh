#!/usr/bin/env bash
# Prüft Marketplace und alle Plugins. Aufruf aus dem Repo-Root: ./scripts/validate.sh
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

status=0

echo "== Marketplace"
claude plugin validate . || status=1

for dir in plugins/*/; do
  echo "== Plugin ${dir}"
  claude plugin validate "$dir" || status=1
done

echo "== Jedes Plugin im Marketplace eingetragen"
for dir in plugins/*/; do
  name="$(basename "$dir")"
  if ! grep -q "\"source\": \"./plugins/${name}\"" .claude-plugin/marketplace.json; then
    echo "FEHLT in marketplace.json: ${name}"
    status=1
  fi
done

exit "$status"
