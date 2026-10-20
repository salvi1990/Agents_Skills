#!/bin/bash
# Setup-Skript für Cloud-Umgebungen (claude.ai/code → Umgebung → „Setup-Skript“).
# Installiert die Plugins aus diesem Marketplace für den Benutzer der Cloud-VM,
# bevor Claude Code startet. Gilt für jede Sitzung in dieser Umgebung, egal welches Repo.
#
# Voraussetzung: Die Umgebung muss github.com erreichen, also Netzwerkzugriff
# „Vertrauenswürdig“, oder bei „Eingeschränkt“ github.com in den erlaubten Domains.
#
# Plugins hinzufügen/entfernen: Liste PLUGINS anpassen.
# Neuere Version erzwingen: STAND ändern. Jede Änderung am Skript baut den
# Umgebungs-Cache neu, sonst läuft das Skript erst nach ca. 7 Tagen wieder.
# Protokoll in der Sitzung ansehen: cat ~/.claude/agents-skills-setup.log
STAND="2026-10-20"

MARKETPLACE_REPO="salvi1990/Agents_Skills"
PLUGINS="dev-team workflow"

# Über HTTPS klonen; SSH ist in Cloud-Umgebungen meist nicht eingerichtet.
export CLAUDE_CODE_PLUGIN_PREFER_HTTPS=1

# Privates Repo: Token als Umgebungsvariable AGENTS_SKILLS_TOKEN in der Cloud-Umgebung
# hinterlegen (Fine-grained PAT, nur dieses Repo, nur „Contents: Read“).
# Der Token gilt nur für die Befehle in diesem Skript und nur für dieses Repo;
# er wird nicht in die Git-Konfiguration geschrieben.
if [ -n "$AGENTS_SKILLS_TOKEN" ]; then
  export GIT_CONFIG_COUNT=1
  export GIT_CONFIG_KEY_0="url.https://x-access-token:${AGENTS_SKILLS_TOKEN}@github.com/${MARKETPLACE_REPO}.insteadOf"
  export GIT_CONFIG_VALUE_0="https://github.com/${MARKETPLACE_REPO}"
fi

mkdir -p ~/.claude
{
  echo "== $(date) STAND=$STAND"
  claude plugin marketplace add "$MARKETPLACE_REPO" || claude plugin marketplace update agents-skills
  for p in $PLUGINS; do
    claude plugin install "${p}@agents-skills"
    claude plugin update "${p}@agents-skills"
  done
  claude plugin list
} >> ~/.claude/agents-skills-setup.log 2>&1

# Nie mit Fehler enden, sonst startet die Sitzung nicht.
exit 0
